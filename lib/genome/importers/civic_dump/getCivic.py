import requests

genes = ["gene_symbol"]
drugs = ["drug_name"]
ids = ["entrez_gene_id"]
int = ["interaction_type"]

for x in range(1,80):
	url = 'https://civic.genome.wustl.edu/api/genes/' + str(x)
	resp = requests.get(url).json()
	gene = resp['name']
	id = resp['entrez_id'] 

	for item in resp['variants']:
		url = 'https://civic.genome.wustl.edu/api/variants/' + str(item['id']) + '/evidence_items'
		evidence = requests.get(url).json()
		for item in evidence:
			for x in item['drugs']:
				if x['name'] != "N/A":
					genes.append(gene)
					drugs.append(x['name'])
					ids.append(id)
					int.append("N/A")
			
with open("civic_dgi.tsv", "w+") as f:
	for i in range(0, len(genes)-1):
		f.write(genes[i].encode('ascii','ignore') + '\t' + str(ids[i]) + '\t' + drugs[i].encode('ascii','ignore') + '\t' + int[i] + '\n')




    
    

