module Genome
  module Importers
    module CarisMolecularIntelligence
      
      def self.source_info
        {
          base_url: 'http://www.carismolecularintelligence.com/profilemenu',
          site_url: 'http://www.carismolecularintelligence.com/',
          citation: 'http://www.carismolecularintelligence.com/',
          source_db_version: Time.new().strftime("%d-%B-%Y"),
          source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name: 'CarisMolecularIntelligence',
          full_name: 'Caris Molecular Intelligence',
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,

        }
      end
      
      def self.run(tsv_path)
        TSVImporter.import tsv_path, CarisMolecularIntelligenceRow, source_info, header=false do
          gene :gene_symbol, nomenclature: 'Gene Symbol' do
            category 'CLINICALLY ACTIONABLE'
          end
        end.save!
      end
    end
  end
end
