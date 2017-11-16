import csv

snp_dict = {}

snp_file = '/Users/kcotto/Downloads/variants/variants.tsv'
pharmgkb_file = '/Users/kcotto/Downloads/PharmGKB-Relationships-2017/relationships.tsv'

with open(snp_file, 'r') as snp:
    reader = csv.DictReader(snp, delimiter='\t')
    header = reader.fieldnames
    for line in reader:
        snp_dict[line['Variant Name']] = line['Gene Symbols']

with open(pharmgkb_file, 'r') as pharmgkb, open('PharmGKB_clean.tsv', 'w') as tmp:
    pharmgkb_reader = csv.reader(pharmgkb, delimiter='\t')
    tmp.write('\t'.join(['GeneID', 'Gene', 'ChemicalID', 'Chemical', 'Evidence', 'Association', 'PK', 'PD', 'PMIDs', 'VariantID']) + '\n')
    for line in pharmgkb_reader:
        if (line[2] == 'Gene' and line[5] == 'Chemical') or (line[2] == 'Chemical' and line[5] == 'Gene'):
            if line[2] == 'Chemical':
                tmp.write('\t'.join([line[3], line[4], line[0], line[1]]) + '\t' + '\t'.join(line[6:]) + '\tN/A\n')
            else:
                tmp.write('\t'.join([line[0], line[1], line[3], line[4]]) + '\t' + '\t'.join(line[6:]) + '\tN/A\n')
        if line[2] == 'Variant' and line[5] == 'Chemical':
            variant = line[1]
            if variant in snp_dict and snp_dict[variant] != '':
                line[1] = snp_dict[line[1]]
                line[2] = 'Gene'
                tmp.write('\t'.join([line[0], line[1], line[3], line[4]]) + '\t' + '\t'.join(line[6:]) + '\t' + variant + '\n')
            elif variant not in snp_dict:
                print(variant)

