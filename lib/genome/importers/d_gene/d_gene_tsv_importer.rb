module Genome
  module Importers
    module DGene

      def source_info
        {
          base_url:           'http://www.ncbi.nlm.nih.gov/gene?term=',
          site_url:           'http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067980',
          citation:           'Prioritizing Potentially Druggable Mutations with dGene: An Annotation Tool for Cancer Genome Sequencing Data. Kumar RD, Chang LW, Ellis MJ, Bose R. PLoS One. 2013 Jun 27;8(6):e67980. PMID: 23826350.',
          source_db_version:  '27-Jun-2013',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name:     'dGene',
          full_name:          'dGENE - The Druggable Gene List',
          license: 'Creative Commons Attribution License (Version not specified)',
          license_link: 'https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067980#pone.0067980.s002',
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
