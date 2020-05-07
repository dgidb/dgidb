module Genome
  module Importers
    module Tempus
      def self.source_info
        {
          base_url:           'https://www.tempus.com/',
          site_url:           'https://www.tempus.com/',
          citation:           'https://www.tempus.com/clinical-validation-of-the-tempus-xt-next-generation-targeted-oncology-sequencing-assay/',
          source_db_version:  '11-November-2018',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name:     'Tempus',
          full_name:          'Tempus xT'
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, TempusRow, source_info do
          gene :gene_symbol, nomenclature: 'Tempus Gene Symbol' do
            name :gene_symbol, nomenclature: 'Gene Symbol', transform: ->(x) { x.upcase }
            category 'ClINICALLY ACTIONABLE'
          end
        end.save!
      end
    end
  end
end
