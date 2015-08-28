import requests
import sys
from version_logger import Version

civic_ids = ["civic_ids"]
genes = ["gene_symbol"]
drugs = ["drug_name"]
entrez_ids = ["entrez_gene_id"]
interaction_type = ["interaction_type"]

url = 'https://civic.genome.wustl.edu/api/genes?count=100000'
resp = sorted(requests.get(url).json(), key=lambda key: int(key['id']))

count = 0
for gene in resp:
    i = gene['id']
    count += 1
    gene_name = gene['name']
    entrez_id = gene['entrez_id']
    sys.stdout.write("Parsing gene {0} of {1}...\r".format(count, len(resp)))
    sys.stdout.flush()

    for variant in gene['variants']:
        url = 'https://civic.genome.wustl.edu/api/variants/' + str(variant['id']) + '/evidence_items'
        evidence = requests.get(url).json()
        for item in evidence:
            if item['evidence_type'] == 'Predictive' and item['evidence_direction'] == 'Supports' and item['evidence_level'] != 'E' and item['rating'] > 2:
                for x in item['drugs']:
                    civic_ids.append(i)
                    genes.append(gene_name)
                    drugs.append(x['name'])
                    entrez_ids.append(entrez_id)
                    interaction_type.append("N/A")

with open("civic_dgi.tsv", "w+") as f:
    for i in range(len(civic_ids)):
        f.write("\t".join((str(civic_ids[i]), genes[i], str(entrez_ids[i]),
                           drugs[i], interaction_type[i])) + "\n")

version = Version('CIViC', append_date=True)
version.write_log()

print('Done.')
