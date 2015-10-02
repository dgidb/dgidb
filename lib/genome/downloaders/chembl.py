
# coding: utf-8

# In[1]:

import postgresql
from collections import Counter, defaultdict
import csv


# In[2]:

db = postgresql.open("pq://localhost/chembl_20")


# In[3]:

ps = db.prepare("SELECT * FROM drug_mechanism")


# In[4]:

columns = ps.column_names
interactions = list()
for row in ps:
    row_dict = dict(zip(columns, row))
    interactions.append(row_dict)


# In[5]:

# There are 2,266 drug <-> gene interactions
len(interactions)


# In[6]:

# There are no duplicate drug <-> gene interactions
c = Counter()
for v in interactions:
    c[(v['record_id'], v['tid'])] += 1
print(len([x for x in c if c[x] > 1]))


# In[7]:

len([x for x in interactions if x['tid'] is None])


# In[8]:

x = [str(x['mec_id']) for x in interactions]
r = db.prepare("SELECT * FROM mechanism_refs WHERE mec_id in ({0})".format(", ".join(x)))
refs = defaultdict(list)
columns = r.column_names
for row in r():
    d = dict(zip(columns, row))
    refs[d['mec_id']].append(d)


# In[9]:

# TODO: Look at the source table linked to by the src_id and src_compound_id fields 
#       in the compound_records table

drug_info = defaultdict(dict)
x = [str(x['record_id']) for x in interactions]
sql = """
SELECT * FROM 
compound_records cr,
molecule_dictionary md
WHERE 
record_id in ({0}) and
cr.molregno = md.molregno
""".format(', '.join(x))
d = db.prepare(sql)
columns = d.column_names
c = Counter()
record_id = dict()
for row in d():
    row_dict = dict(zip(columns, row))
    record = row['record_id']
    c[row['molregno']] += 1
    record_id[row['molregno']] = record
    drug_info[record]['drug_name'] = row['pref_name']
    drug_info[record]['chembl_id'] = row['chembl_id']
    # TODO: Add in alt_source id. See the 'src_id' and 'src_compound_id'.

drug_filter = [record_id[x] for x in c if c[x] > 1]
    # Four drugs where there are multiple chembl entries for the record. 


# In[10]:

# Select all interactions involving multiple genes, and remove from interaction list

sql = """
select dm.tid, dm.record_id, count(dm.tid) from 
    drug_mechanism dm,
    target_dictionary td,
    target_components tc
where
    dm.tid = td.tid and
    td.tid = tc.tid
group by dm.tid, dm.record_id
having
    count(dm.tid) > 1
"""

filter_query = db.prepare(sql)
columns = filter_query.column_names
filter_list = list()
for row in filter_query():
    d = dict(zip(columns, row))
    filter_list.append((d['tid'], d['record_id']))
filtered_interactions =     list(filter(lambda x: (x['tid'], x['record_id']) not in filter_list, interactions))
print(len(filtered_interactions))
filtered_interactions = list(filter(lambda x: x['tid'] is not None, filtered_interactions))
print(len(filtered_interactions))
filtered_interactions = list(filter(lambda x: x['record_id'] not in drug_filter,
                                    filtered_interactions))
print(len(filtered_interactions))


# In[11]:

x = [str(x['tid']) for x in filtered_interactions]
count = 0 # Test to see how many table entries lack an actual synonym in the synonym field.
def dd_l():
    return (defaultdict(set))
gene_info = defaultdict(dd_l)
sql = """
SELECT tc.tid, td.chembl_id, cs.* FROM 
    component_synonyms cs,
    target_components tc,
    target_dictionary td
WHERE
    cs.component_id = tc.component_id and
    tc.tid = td.tid and
    td.tid in ({0})
""".format(', '.join(x))
g = db.prepare(sql)
columns = g.column_names
for row in g():
    row_dict = dict(zip(columns, row))
    tid = row_dict['tid']
    gene_info[tid]['CHEMBL_ID'] = row_dict['chembl_id']
    syn_type = row_dict['syn_type']
    try:
        synonym = row_dict['component_synonym'].strip()
    except AttributeError:
        count += 1
        continue
    if syn_type == 'UNIPROT':
        gene_info[tid]['UNIPROT_NAME'].add(synonym)
        gene_info[tid]['UNIPROT_ID'].add(row_dict['compsyn_id'])
    elif syn_type == 'GENE_SYMBOL':
        gene_info[tid]['GENE_SYMBOL'].add(synonym)
print(count)


# In[17]:

delim = '|'
for interaction in filtered_interactions:
    key = interaction['mec_id']
    interaction['FDA'] = list()
    interaction['pmid'] = list()
    for r in refs[key]:
        if r['ref_type'] == 'FDA':
            interaction['FDA'].append(r['ref_id'])
        elif r['ref_type'] == 'PubMed':
            interaction['pmid'].append(r['ref_id'])
    interaction['FDA'] = delim.join(tuple(interaction['FDA']))
    interaction['pmid'] = delim.join(tuple(interaction['pmid']))
    
    key = interaction['tid']
    gi = gene_info[key]
    interaction['gene_chembl_id'] = gi['CHEMBL_ID']
    interaction['gene_symbol'] = delim.join(tuple(gi['GENE_SYMBOL']))
    interaction['uniprot_id'] = delim.join(tuple([str(x) for x in gi['UNIPROT_ID']]))
    interaction['uniprot_name'] = delim.join(tuple(gi['UNIPROT_NAME']))
    
    key = interaction['record_id']
    interaction['drug_name'] = drug_info[key]['drug_name']
    interaction['drug_chembl_id'] = drug_info[key]['chembl_id']
    
    if interaction['molecular_mechanism'] == 0:
        interaction['action_type'] = None
        
    if interaction['direct_interaction'] == 1:
        interaction['direct_interaction'] = 'yes'
    else:
        interaction['direct_interaction'] = 'no'


# In[18]:

count = 0
for key in gene_info:
    if len(gene_info[key]['GENE_SYMBOL']) == 0:
        count += 1
count


# In[20]:

interaction


# In[24]:

header = ('drug_chembl_id', 'drug_name', 'gene_chembl_id', 'gene_symbol', 'uniprot_id', 
          'uniprot_name', 'action_type', 'mechanism_of_action',
          'direct_interaction', 'FDA', 'pmid')
with open('data/chembl.tsv', 'w') as f:
    writer = csv.DictWriter(f, header, extrasaction='ignore', delimiter='\t')
    writer.writeheader()
    for row in filtered_interactions:
        writer.writerow(row)



