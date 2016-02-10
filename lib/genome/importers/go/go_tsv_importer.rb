module Genome
  module Importers
    module Go

      def self.get_version
        f = File.join([Rails.root.to_s, 'lib/genome/updaters/data/version'])
        File.open(f).readlines.each do |line|
          source, version = line.split("\t")
          if source == 'GO'
            return version.strip
          end
        end
        return nil
      end

      def self.source_info
        {
          base_url:           'http://amigo.geneontology.org/amigo/gene_product/UniProtKB:',
          site_url:           'http://www.geneontology.org/',
          citation:           'Gene ontology: tool for the unification of biology. The Gene Ontology Consortium. Ashburner M, Ball CA, ..., Rubin GM, Sherlock G. Nat Genet. 2000 May;25(1):25-9. PMID: 10802651.',
          source_db_version:  get_version,
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'GO',
          full_name:          'The Gene Ontology'
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? || x == "''" || x == '""' || x == '-'}
        TSVImporter.import tsv_path, GoRow, source_info do
          gene :gene_name, nomenclature: 'Gene Symbol' do
            names :uniprot_ids, nomenclature: 'UniProt ID', unless: blank_filter
            category :gene_category
          end
        end.save!
      end
    end
  end
end
