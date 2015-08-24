import requests
import sys
from version_logger import Logger

genes = ["gene_symbol"]
drugs = ["drug_name"]
entrez_ids = ["entrez_gene_id"]
interaction_type = ["interaction_type"]

gene_count = 80  # TODO: Write a scraper that identifies the number of genes and updates this. Or go until 404.

for i in range(gene_count):
    i += 1
    sys.stdout.write("Parsing gene {0} of {1}...\r".format(i, gene_count))
    sys.stdout.flush()
    url = 'https://civic.genome.wustl.edu/api/genes/' + str(i)
    resp = requests.get(url).json()
    gene = resp['name']
    entrez_id = resp['entrez_id']

    for variant in resp['variants']:
        url = 'https://civic.genome.wustl.edu/api/variants/' + str(variant['id']) + '/evidence_items'
        evidence = requests.get(url).json()
        for item in evidence:
            for x in item['drugs']:
                if x['name'] != "N/A":
                    genes.append(gene)
                    drugs.append(x['name'])
                    entrez_ids.append(entrez_id)
                    interaction_type.append("N/A")

with open("data/civic_dgi.tsv", "w") as f:
    for i in range(len(genes)):
        f.write("\t".join((genes[i], str(entrez_ids[i]),
                           drugs[i], interaction_type[i])) + "\n")

version = Logger('CIViC')
version.log()

print('Done.')
