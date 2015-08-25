__author__ = 'Alex H Wagner'
import wget
import os
import gzip
import csv
from version_logger import Version
from bs4 import BeautifulSoup
from urllib.request import urlopen
import datetime


class Entrez:

    def __init__(self):
        self.online_version = None
        self.get_online_version()
        self.version = Version('Entrez', version=self.online_version)
        self.logged_version = self.version.last_logged_version()

    def is_current(self):
        """Returns True if local versions of Entrez files are up-to-date."""
        return self.version.is_current()

    def get_online_version(self):
        # This assumes that if gene2accession needs updating, so will other Entrez files.
        html = urlopen('http://ftp.ncbi.nlm.nih.gov/gene/DATA/')
        bsObj = BeautifulSoup(html.read(), "html.parser")
        a = bsObj.hr.find('a', {"href": "gene2accession.gz"})
        self.online_version = datetime.datetime.strptime(a.next.next.split()[0], '%d-%b-%Y').strftime('%d-%B-%Y')

    @staticmethod
    def extract(file):
        with gzip.open(file, 'rb') as rf:
            with open('data/' + file.rsplit('.', 1)[0] + '.human', 'w') as wf:
                for line in rf:
                    line_ascii = line.decode('utf-8')
                    species = line_ascii.split()[0]
                    if species == '9606':  # Grab human only
                        wf.write(line_ascii)

    @staticmethod
    def download_files():
        """Download and extract the gene2accession and gene_info files"""
        print('Downloading Entrez Accessions...')
        print('gene_info:')
        g2a_filename = wget.download("ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz")
        print('\ngene2accession:')
        gi_filename = wget.download("ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz")
        print('\nExtracting Entrez Accessions...')
        print('gene_info...')
        Entrez.extract("gene_info.gz")
        print('gene2accession...')
        Entrez.extract("gene2accession.gz")
        os.remove(g2a_filename)
        os.remove(gi_filename)

    def parse(self):
        self.rows = []
        with open('data/gene_info.human') as f:
            fieldnames = ['tax_id', 'entrez_id', 'entrez_gene_symbol', 'locus_tag',
                         'entrez_gene_synonyms', 'dbXrefs', 'chromosome', 'map_loc',
                         'description', 'type', 'sym_from_auth', 'full_from_auth',
                         'nom_status', 'other_designations', 'mod_date']
            reader = csv.DictReader(f, delimiter='\t', fieldnames=fieldnames)
            for row in reader:
                ensembl = set()
                for key, value in row.items():
                    if value == '-':
                        row[key] = 'N/A'
                dbXrefs = row['dbXrefs'].split('|')
                for xRef in dbXrefs:
                    if xRef == 'N/A':
                        continue
                    source, label = xRef.split(':', 1)
                    if source == 'Ensembl':
                        ensembl.add(label)
                row['ensembl_ids'] = '|'.join(ensembl) or 'N/A'
                self.rows.append(row)

    def write(self):
        with open('data/entrez_genes.tsv', 'w') as f:
            fieldnames = ['entrez_id', 'entrez_gene_symbol', 'entrez_gene_synonyms',
                          'ensembl_ids', 'description']
            writer = csv.DictWriter(f, delimiter='\t', fieldnames=fieldnames, extrasaction='ignore')
            writer.writeheader()
            writer.writerows(self.rows)
        self.version.write_log()

    def update(self):
        if not self.is_current():
            self.download_files()
            self.parse()
            self.write()


if __name__ == '__main__':
    e = Entrez()
    e.update()
    print('Done.')
