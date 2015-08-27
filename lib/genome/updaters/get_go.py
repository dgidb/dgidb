import wget
import os
import csv
from version_logger import Version

__author__ = 'Alex H Wagner'


class GO:

    def __init__(self):
        # These were assembled from the original DGIdb identifiers
        self.dgidb_go_terms = [{"short_name": "Kinase", "full_go_name": "KinaseActivity",
             "human_readable": "Kinase", "go_id": "GO0016301"},
            {"short_name": "TyrosineKinase", "full_go_name": "ProteinTyrosineKinaseActivity",
             "human_readable": "Tyrosine Kinase", "go_id": "GO0004713"},
            {"short_name": "SerineThreonineKinase", "full_go_name": "ProteinSerineThreonineKinaseActivity",
             "human_readable": "Serine Threonine Kinase", "go_id": "GO0004674"},
            {"short_name": "ProteinPhosphatase", "full_go_name": "PhospoproteinPhosphataseActivity",
             "human_readable": "Protein Phosphatase", "go_id": "GO0004721"},
            {"short_name": "GProteinCoupledReceptor", "full_go_name": "GpcrActivity",
             "human_readable": "G Protein Coupled Receptor", "go_id": "GO0004930"},
            {"short_name": "NeutralZincMetallopeptidases", "full_go_name": "MetallopeptidaseActivity",
             "human_readable": "Neutral Zinc Metallopeptidase", "go_id": "GO0008237"},
            {"short_name": "ABCTransporter", "full_go_name": "ABCTransporterActivity",
             "human_readable": "ABC Transporter", "go_id": "GO0042626"},
            {"short_name": "RNADirectedDNAPolymerase", "full_go_name": "RNADirectedDnaPolymeraseActivity",
             "human_readable": "RNA Directed DNA Polymerase", "go_id": "GO0003964"},
            {"short_name": "Transporter", "full_go_name": "TransporterActivity",
             "human_readable": "Transporter", "go_id": "GO0005215"},
            {"short_name": "IonChannel", "full_go_name": "IonChannelActivity",
             "human_readable": "Ion Channel", "go_id": "GO0005216"},
            {"short_name": "NuclearHormoneReceptor", "full_go_name": "LigandDependentNuclearReceptorActivity",
             "human_readable": "Nuclear Hormone Receptor", "go_id": "GO0004879"},
            {"short_name": "LipidKinase", "full_go_name": "LipidKinaseActivity",
             "human_readable": "Lipid Kinase", "go_id": "GO0001727"},
            {"short_name": "Phospholipase", "full_go_name": "PhospholipaseActivity",
             "human_readable": "Phospholipase", "go_id": "GO0004620"},
            {"short_name": "ProteaseInhibitorActivity", "full_go_name": "PeptidaseInhibitorActivity",
             "human_readable": "Protease Inhibitor", "go_id": "GO0030414"},
            {"short_name": "DNARepair", "full_go_name": "DnaRepair",
             "human_readable": "DNA Repair", "go_id": "GO0006281"},
            {"short_name": "CellSurface", "full_go_name": "CellSurface",
             "human_readable": "Cell Surface", "go_id": "GO0009986"},
            {"short_name": "ExternalSideOfPlasmaMembrane", "full_go_name": "ExternalSideOfPlasmaMembrane",
             "human_readable": "External Side Of Plasma Membrane", "go_id": "GO0009897"},
            {"short_name": "GrowthFactor", "full_go_name": "GrowthFactorActivity",
             "human_readable": "Growth Factor", "go_id": "GO0008083"},
            {"short_name": "HormoneActivity", "full_go_name": "HormoneActivity",
             "human_readable": "Hormone Activity", "go_id": "GO0005179"},
            {"short_name": "TumorSuppressor", "full_go_name": "RegulationOfCellCycle",
             "human_readable": "Tumor Suppressor", "go_id": "GO0051726"},
            {"short_name": "TranscriptionFactorBinding", "full_go_name": "TranscriptionFactorBinding",
             "human_readable": "Transcription Factor Binding", "go_id": "GO0008134"},
            {"short_name": "TranscriptionFactorComplex", "full_go_name": "TranscriptionFactorComplex",
             "human_readable": "Transcription Factor Complex", "go_id": "GO0005667"},
            {"short_name": "HistoneModification", "full_go_name": "HistoneModification",
             "human_readable": "Histone Modification", "go_id": "GO0016570"},
            {"short_name": "DrugMetabolism", "full_go_name": "DrugMetabolism",
             "human_readable": "Drug Metabolism", "go_id": "GO0017144"},
            {"short_name": "DrugResistance", "full_go_name": "ResponseToDrug",
             "human_readable": "Drug Resistance", "go_id": "GO0042493"},
            {"short_name": "ProteaseActivity", "full_go_name": "PeptidaseActivity",
             "human_readable": "Protease", "go_id": "GO0008233"}]

        #TODO: Use http://www.ebi.ac.uk/QuickGO/GHistory#info=2 for versioning.
        self.version = Version('GO', append_date=True)
        self.logged_version = self.version.last_logged_version()

        self.rows = []

    def is_current(self):
        """Returns True if local versions of Entrez files are up-to-date."""
        return self.version.is_current()

    def download_files(self):
        """Download and extract the gene2accession and gene_info files"""
        go_ids = [':'.join((x['go_id'][:2], x['go_id'][2:])) for x in self.dgidb_go_terms]
        url = 'http://www.ebi.ac.uk/QuickGO/GAnnotation?format=tsv&limit=-1&gz=false&tax=9606&goid='
        os.makedirs('data/GO', exist_ok=True)
        for go_id in go_ids:
            file = 'data/GO/' + go_id.replace(':','') + '.tsv'
            try:
                os.remove(file)
            except FileNotFoundError:
                pass
            wget.download(url + go_id, out=file)

    def parse(self):
        self.rows = []
        go_ids = [':'.join((x['go_id'][:2], x['go_id'][2:])) for x in self.dgidb_go_terms]
        category_lookup = {x['go_id']: x['human_readable'].upper() for x in self.dgidb_go_terms}
        for go_id in go_ids:
            category = category_lookup[go_id.replace(':', '')]
            file = 'data/GO/' + go_id.replace(':', '') + '.tsv'
            with open(file, 'r') as f:
                reader = csv.DictReader(f, delimiter='\t')
                for row in reader:
                    row['Category'] = category
                    self.rows.append(row)

    def write(self):
        fieldnames = ['ID', 'Symbol', 'Category']
        with open('data/go.human.tsv', 'w') as f:
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
    e = GO()
    e.update()
    print('Done.')