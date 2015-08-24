__author__ = 'Alex H Wagner'

import datetime
import warnings
import csv


class Logger:

    def __init__(self, source, version=None, append_date=True):
        self.version = version
        self.append = append_date
        self.source = source
        if self.version is None and not self.append:
            self.append = True
            warnings.warn("No version specified, setting logger to use date instead.")

    def log(self):
        versions = dict()
        with open('data/version', 'r') as f:
            for line in f:
                key, value = line.strip().split('\t')
                versions[key] = value
        if self.append:
            today = datetime.date.today().strftime("%d-%B-%Y")
            if self.version is not None:
                version = "{0}, {1}".format(self.version, today)
            else:
                version = today
        else:
            version = str(self.version)
        versions[self.source] = version
        with open('data/version', 'w') as f:
            writer = csv.writer(f, delimiter='\t')
            for source in sorted(versions):
                writer.writerow((source, versions[source]))
