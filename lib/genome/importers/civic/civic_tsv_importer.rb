module Genome
  module Importers
    module Civic

      def self.get_version
        File.open('lib/genome/updaters/data/version').readlines.each do |line|
          source, version = line.split("\t")
          if source == 'CIViC'
            return version.strip
          end
        end
        return nil
      end
    
      def self.source_info
        {
          base_url: 'https://civic.genome.wustl.edu',
          site_url: 'https://www.civicdb.org',
          citation: 'CIViC: Clinical Interpretations of Variants in Cancer',
          source_db_version: get_version,
          source_type_id: DataModel::SourceType.INTERACTION,
          source_db_name: 'CIViC',
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          full_name: 'CIViC: Clinical Interpretations of Variants in Cancer'
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? }
        upcase = ->(x) { x.upcase }
        TSVImporter.import tsv_path, CivicRow, source_info do
          interaction known_action_type: 'unknown' do
            drug :drug_name, nomenclature: 'CIViC Drug Name', primary_name: :drug_name, transform: upcase do
            end
            gene :civic_id, nomenclature: 'CIViC Gene ID' do
              name :entrez_gene_id, nomenclature: 'Entrez Gene ID', unless: blank_filter
              name :gene_symbol, nomenclature: 'Entrez Gene Symbol', unless: blank_filter
            end

            attribute :interaction_type, name: 'Interaction Type', unless: blank_filter
          end
        end.save!
      end
    end
  end
end

