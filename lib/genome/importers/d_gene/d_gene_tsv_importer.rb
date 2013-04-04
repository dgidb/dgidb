module Genome
  module Importers
    module DGene

      def source_info
        {
          base_url:           'http://www.ncbi.nlm.nih.gov/gene?term=',
          site_url:           'http://hematology.wustl.edu/faculty/Bose/BoseBio.html',
          citation:           'The Druggable Gene List, dGENE, provides a Rapid Filter for Cancer Genome Sequencing Data. Kumar R, Chang L, Ellis MJ, Bose R. Manuscript in preparation.',
          source_db_version:  '02-Aug-2012',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'dGene',
          full_name:          'dGENE - The Druggable Gene List'
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, DGeneRow, source_info do
          gene :gene_id, nomenclature: 'dGene Gene Id' do
            name :symbol, nomenclature: 'Gene Symbol', transform: ->(x) { x.upcase }
            name :gene_id, nomenclature: 'Entrez Gene Id', transform: ->(x) { x.upcase }
            attribute :human_readable_name, name: 'Human Readable Name', transform: ->(x) { x.gsub('-', ' ').upcase }, unless: ->(x) { x.downcase == 'n/a' }
          end
        end
      end
    end
  end
end