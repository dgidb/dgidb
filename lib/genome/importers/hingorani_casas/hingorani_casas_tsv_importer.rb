module Genome
  module Importers
    module HingoraniCasas
      def self.source_info
        {
          base_url:           'http://stm.sciencemag.org/content/9/383/eaag1166',
          site_url:           'http://stm.sciencemag.org/content/9/383/eaag1166',
          citation:           'The druggable genome and support for target identification and validation in drug development. Finan C, Gaulton A, Kurger F, Lumbers T, Shah T, Engmann J, Galver L, Kelly R, Karlsson A, Santos R, Overington J, Hingorani A, Casas JP.   Sci. Transl. Med. 2017 Mar 29;9(383):eaag1166 PMID: 28356508.',
          source_db_version:  '31-May-2017',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name:     'HingoraniCasas',
          full_name:          'The druggable genome and support for target identification and validation in drug development (Hingorani & Casas, 2017)',
          license: 'Supplementary data from Author Copyright publication',
          license_link: 'https://stm.sciencemag.org/content/9/383/eaag1166/tab-pdf',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, HingoraniCasasRow, source_info do
          gene :gene_symbol, nomenclature: 'HingoraniCasas Gene Symbol' do
            name :gene_symbol, nomenclature: 'Gene Symbol', transform: ->(x) { x.upcase }
            name :ensembl_id, nomenclature: 'Ensembl Id', transform: ->(x) { x.upcase }
            category 'DRUGGABLE GENOME'
          end
        end.save!
      end
    end
  end
end
