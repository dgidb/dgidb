__author__ = 'Alex H Wagner'
import wget
import os
import gzip
from version_logger import Version
from bs4 import BeautifulSoup
from urllib.request import urlopen


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
        self.online_version = a.next.next.split()[0]

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
        print('File 1:')
        g2a_filename = wget.download("ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz")
        print('\nFile 2:')
        gi_filename = wget.download("ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz")
        print('\nExtracting Entrez Accessions...')
        print('File 1...')
        Entrez.extract("gene_info.gz")
        print('File 2...')
        Entrez.extract("gene2accession.gz")
        os.remove(g2a_filename)
        os.remove(gi_filename)

    def update(self):
        if not self.is_current():
            self.download_files()
            self.version.write_log()


if __name__ == '__main__':
    e = Entrez()
    e.update()
    print('Done.')
