__author__ = 'Alex H Wagner'

import wget
import zipfile
import os
import gzip
import xml.etree.ElementTree as ET
import csv
import re
from version_logger import Logger
from urllib.request import urlopen
from bs4 import BeautifulSoup


# Pull files from web
# ===
print('Downloading DrugBank XML...')
filename = wget.download("http://www.drugbank.ca/system/downloads/current/drugbank.xml.zip")

print('\nExtracting DrugBank XML...')
zfile = zipfile.ZipFile(filename)
zfile.extract('drugbank.xml', 'data/new.drugbank.xml')
os.remove(filename)

def extract(file):
    with gzip.open(file, 'rb') as rf:
        with open('data/' + file.rsplit('.',1)[0] + '.human', 'w') as wf:
            for line in rf:
                line_ascii = line.decode('utf-8')
                species = line_ascii.split()[0]
                if species == '9606':  # Grab human only
                    wf.write(line_ascii)

print('Downloading Entrez Accessions...')
print('File 1:')
g2a_filename = wget.download("ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz")
print('\nFile 2:')
gi_filename = wget.download("ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz")
print('\nExtracting Entrez Accessions...')
print('File 1...')
extract("gene_info.gz")
print('File 2...')
extract("gene2accession.gz")
os.remove(g2a_filename)
os.remove(gi_filename)


# Process DrugBank XML
# ===
# 
# Check Database Version
# ---

print('Checking DrugBank Version...')
html = urlopen('http://www.drugbank.ca/downloads')
bsObj = BeautifulSoup(html.read(), "html.parser")

r = re.compile(r'Version ([\d\.]+)')
match = r.search(bsObj.h1.text)
if match:
    version = match.group(1)
else:
    raise ValueError('Did not load version.') 


# Load gene annotation resources
# ---

print('Parsing Entrez...')
symbol_to_info = dict()
hgnc_id_to_info = dict()
entrez_to_info = dict()
sources = set()
with open('data/gene_info.human') as f:
    c = csv.reader(f, delimiter='\t')
    for line in c:
        if line[0] != '9606':
            continue
        gene_symbol = line[2]
        entrez_id = line[1]
        symbol_to_info[gene_symbol] = {'Entrez': entrez_id,
                                       'Symbol': gene_symbol}
        if line[5] == '-':
            continue
        synonyms = line[5].split('|')
        for synonym in synonyms:
            (source, accession) = synonym.split(':', 1)
            symbol_to_info[gene_symbol][source] = accession
            sources.add(source)
        if 'HGNC' in symbol_to_info[gene_symbol]:
            hgnc_id_to_info[symbol_to_info[gene_symbol]['HGNC']] = symbol_to_info[gene_symbol]
        entrez_to_info[entrez_id] = symbol_to_info[gene_symbol]

uniprot_to_entrez = dict()
r = re.compile(r'[OPQ][0-9][A-Z0-9]{3}[0-9]|[A-NR-Z][0-9]([A-Z][A-Z0-9]{2}[0-9]){1,2}')
    # regex from: http://www.uniprot.org/help/accession_numbers
with open('data/gene2accession.human') as f:
    c = csv.reader(f, delimiter='\t')
    for line in c:
        if line[0] != '9606':
            continue
        uniprot_id = line[5].split('.',1)[0]
        if not r.match(uniprot_id):
            continue
        entrez_id = line[1]
        uniprot_to_entrez[uniprot_id] = entrez_id

# Parse XML
# ---
print('Parsing DrugBank XML...')
ns = {'entry': 'http://www.drugbank.ca'}

tree = ET.parse('data/new.drugbank.xml')
drugbank = tree.getroot()
drugs = drugbank.findall('entry:drug', ns)

interactions = dict()
drug_info = dict()
uniprot_fail = uniprot_success = 0
hgnc_fail = hgnc_success = 0
no_info = info = no_ensembl = 0
total = 0
for drug in drugs:
    drug_id = drug.find('entry:drugbank-id', ns).text
    drug_name = drug.find('entry:name', ns).text
    
    synonyms = drug.find('entry:synonyms', ns)
    drug_synonyms = set()
    for synonym in synonyms:
        language = synonym.get('language')
        if language == '' or language == 'English':
            drug_synonyms.add(synonym.text)
    drug_cas_number = drug.find('entry:cas-number',ns).text
    drug_brands = set()
    for product in drug.find('entry:products', ns):
        drug_brands.add(product.find('entry:name', ns).text)
    for int_brand in drug.find('entry:international-brands', ns):
        drug_brands.add(int_brand.find('entry:name', ns).text)
    drug_type = drug.get('type')
    drug_groups = set()
    for group in drug.find('entry:groups', ns):
        drug_groups.add(group.text)
    drug_categories = set()
    for category in drug.find('entry:categories', ns):
        drug_categories.add(category.find('entry:category', ns).text)
    targets = drug.find('entry:targets', ns)
    if len(targets) == 0:
        continue
    drug_info[drug_id] = (drug_name, tuple(sorted(drug_synonyms)), drug_cas_number, 
                          tuple(sorted(drug_brands)), drug_type, 
                          tuple(sorted(drug_groups)), tuple(sorted(drug_categories)))
    for target in targets:
        organism = target.find('entry:organism', ns).text
        if organism != 'Human':
            continue
        gene_id = target.find('entry:id',ns).text
        known_action = target.find('entry:known-action', ns).text
        target_actions = set()
        for action in target.find('entry:actions', ns):
            target_actions.add(action.text)
        gene_symbol = hgnc_gene_acc = uniprot_id = entrez_id = ensembl_id = None
        polypeptide = target.find('entry:polypeptide',ns)
        synonyms = None
        if polypeptide is not None:
            gene_symbol = polypeptide.find('entry:gene-name', ns).text
            for identifier in polypeptide.find('entry:external-identifiers',ns):
                if identifier.find('entry:resource',ns).text == 'HUGO Gene Nomenclature Committee (HGNC)':
                    hgnc_gene_acc = identifier.find('entry:identifier',ns).text
                    # Some identifiers are incorrectly labeled by DrugBank
                    r = re.compile(r'^\d+$')
                    if hgnc_gene_acc.startswith('GNC:'):
                        hgnc_gene_acc = 'H' + hgnc_gene_acc
                    elif r.match(hgnc_gene_acc):
                        hgnc_gene_acc = 'HGNC:' + hgnc_gene_acc
                    try:
                        synonyms = hgnc_id_to_info[hgnc_gene_acc]
                    except:
                        hgnc_fail += 1
                    else:
                        entrez_id = synonyms['Entrez']
                        try:
                            ensembl_id = synonyms['Ensembl']
                        except KeyError:
                            no_ensembl += 1
                        hgnc_success += 1
                elif identifier.find('entry:resource',ns).text == 'UniProtKB':
                    uniprot_id = identifier.find('entry:identifier',ns).text
                    if not synonyms:
                        try:
                            entrez_id = uniprot_to_entrez[uniprot_id]
                            synonyms = entrez_to_info[entrez_id]
                        except KeyError:
                            uniprot_fail += 1
                        else:
                            uniprot_success += 1
            if not synonyms:
                try:
                    synonyms = symbol_to_info[gene_symbol]
                except KeyError:
                    no_info += 1
                else:
                    entrez_id = synonyms['Entrez']
                    ensembl_id = synonyms['Ensembl']
                    info += 1
        interaction_tuple = (gene_id, known_action, tuple(sorted(target_actions)), 
                             gene_symbol, uniprot_id, entrez_id, ensembl_id)
        total += 1
        try:
            interactions[drug_id].append(interaction_tuple)
        except KeyError:
            interactions[drug_id] = [interaction_tuple,]


# Write interactions to tsv
# ---
print('Writing to .tsv...')
i = 0
no_ensembl = no_entrez = total = 0
header = ('count','drug_id','drug_name','drug_synonyms','drug_cas_number','drug_brands',
          'drug_type','drug_groups','drug_categories','gene_id','known_action','target_actions',
          'gene_symbol','uniprot_id','entrez_id','ensembl_id')
with open('data/DrugBankInteractions.tsv', 'w') as f:
    writer = csv.writer(f, delimiter='\t')
    writer.writerow(header)
    for drug in sorted(interactions):
        for interaction in interactions[drug]:
            i += 1
            data = (i,drug) + drug_info[drug] + interaction
            out = list()
            for datum in data:
                if isinstance(datum, tuple):
                    datum = ','.join(datum)
                datum = str(datum).replace("\t", '')
                if not datum or datum == 'None':
                    datum = 'N/A'
                out.append(datum)
                # Some small number of rows contain tabs within text.
            if out[14] == 'N/A':
                no_entrez += 1
            if out[15] == 'N/A':
                no_ensembl += 1
            writer.writerow(out)

# Update DGIdb `version` File
# ===

version = Logger('DrugBank', version=version)
version.log()

print('Done.')
