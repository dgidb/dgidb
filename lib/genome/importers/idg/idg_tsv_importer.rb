module Genome
  module Importers
    module IDG

      def self.source_info
        {
          base_url:           'https://druggablegenome.net/IDGProteinList/',
          site_url:           'https://druggablegenome.net/',
          citation:           'Rodgers,G., Austin,C., Anderson,J., Pawlyk,A., Colvis,C., Margolis,R. and Baker,J. (2018) Glimmers in illuminating the druggable genome. Nat. Rev. Drug Discov., 17, 301–302. PMID: 29348682',
          source_db_version:  '15-July-2019',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name:     'IDG',
          full_name:          'Illuminating the Druggable Genome',
          license_text:       'Creative Commons Attribution-ShareAlike 4.0 International License',
          license_link:       'https://druggablegenome.net/IDGPolicies#Policy3',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, IDGRow, source_info, header=true do
          gene :gene_symbol, nomenclature: 'IDG Gene Symbol' do
            name :gene_symbol, nomenclature: 'Gene Symbol', transform: ->(x) { x.upcase }
            attribute :gene_category, name: 'Gene Category'
          end
        end.save!
      end
    end
  end
end
