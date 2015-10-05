import requests
from version_logger import Version
from collections import defaultdict
import csv

header = ('civic_ids', 'gene_symbol', 'drug_names', 'entrez_gene_id', 'interaction_type', 'pmids')
pmids = defaultdict(list)

url = 'https://civic.genome.wustl.edu/api/genes?count=100000'
resp = sorted(requests.get(url).json(), key=lambda key: int(key['id']))

count = 0
for gene in resp:
    i = gene['id']
    count += 1
    gene_name = gene['name']
    entrez_id = gene['entrez_id']
    for variant in gene['variants']:
        url = 'https://civic.genome.wustl.edu/api/variants/' + str(variant['id']) + '/evidence_items'
        evidence = requests.get(url).json()
        for item in evidence:
            try:
                item['evidence_type']
            except TypeError:
                continue
            if item['evidence_type'] == 'Predictive' and item['evidence_direction'] == 'Supports' \
                and item['evidence_level'] != 'E' and item['rating'] > 2:
                for drug in item['drugs']:
                    if drug['name'].upper() == 'N/A' or ';' in drug['name']:  # TODO: Handle multiple names (;)
                        continue
                    key = (i, gene_name, drug['name'], entrez_id, "N/A")
                    pmids[key].append(item['pubmed_id'])


with open("data/civic_dgi.tsv", "w") as f:
    csv_writer = csv.writer(f, delimiter="\t")
    csv_writer.writerow(header)
    for key in pmids:
        row = key + (','.join(pmids[key]),)
        csv_writer.writerow(row)

version = Version('CIViC', append_date=True)
version.write_log()

print('Done.')
