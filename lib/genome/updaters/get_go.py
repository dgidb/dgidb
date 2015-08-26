import wget
import os
import csv
import gzip
from version_logger import Version
from bs4 import BeautifulSoup
from selenium import webdriver
import time
import re
import datetime

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

        url = 'http://geneontology.org/page/download-annotations'

        # This will require PhantomJS installed in your path. For OS X 10.10, go here: https://goo.gl/sjbtQT
        driver = webdriver.PhantomJS(service_log_path='data/ghostdriver.log')
        driver.get(url)
        time.sleep(3)
        html = driver.page_source
        soup = BeautifulSoup(html, "html.parser")
        for parent in soup.find('strong', text='Homo sapiens').parents:
            if parent.name == 'tr':
                break
        if parent:
            self.parent = parent
        else:
            raise ValueError
        date_string = parent.find('td', text=re.compile(r'\d+/\d+/\d+')).text
        self.online_version = datetime.datetime.strptime(date_string, '%m/%d/%Y').strftime('%d-%B-%Y')
        self.version = Version('GO', version=self.online_version)
        self.logged_version = self.version.last_logged_version()

        self.rows = []

    def is_current(self):
        """Returns True if local versions of Entrez files are up-to-date."""
        return self.version.is_current()

    def download_files(self):
        """Download and extract the gene2accession and gene_info files"""
        readme = self.parent.find(text='README').parent.attrs['href']
        download = self.parent.find(text='gene_association.goa_human.gz').parent.attrs['href']
        try:
            os.remove('data/goa_README.txt')
        except FileNotFoundError:
            pass
        try:
            os.remove('data/goa_human.gz')
        except FileNotFoundError:
            pass
        wget.download(readme, out='data/goa_README.txt')
        wget.download(download, out='data/goa_human.gz')
        self.version.write_log()

    def parse(self):
        self.rows = [['uniprot_id', 'gene_name', 'gene_category', 'description']]
        go_ids = [':'.join((x['go_id'][:2], x['go_id'][2:])) for x in self.dgidb_go_terms]
        category_lookup = {x['go_id']: x['human_readable'].upper() for x in self.dgidb_go_terms}
        with gzip.open('data/goa_human.gz', 'rt', encoding='utf-8') as f:
            reader = csv.reader(f, delimiter='\t')
            for row in reader:
                if row[0].startswith('!'):
                    continue
                elif row[4] not in go_ids:
                    continue
                elif row[0] != 'UniProtKB':
                    continue
                elif row[12] != 'taxon:9606':
                    continue
                else:
                    row[4] = category_lookup[row[4].replace(':', '')]
                    self.rows.append([row[x] for x in (1, 2, 4, 9)])

    def write(self):
        with open('data/go.human.tsv', 'w') as f:
            writer = csv.writer(f, delimiter='\t')
            writer.writerows(self.rows)

    def update(self):
        if not self.is_current():
            self.download_files()
            self.parse()
            self.write()


if __name__ == '__main__':
    e = GO()
    e.update()
    print('Done.')