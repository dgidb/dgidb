module Genome
  module Importers
    module Tempus
      
      def self.source_info
        {
          base_url:           'https://www.tempus.com/clinical-validation-of-the-tempus-xt-next-generation-targeted-oncology-sequencing-assay/',
          site_url:           'https://www.tempus.com/',
          citation:           'Beaubier, N, Tell, R, Lau, D, Parsons, JR, Bush, S, Perera, J, Sorrells, S, Baker, T, Chang, A, Michuda, J, Iguartua, C, MacNeil, S, Shah, K, Ellis, P, Yeatts, K, Mahon, B, Taxter, T, Bontrager, M, Khan, A, Huether, R, Lefkofsky, E, & White, KP. Clinical validation of the tempus xT next-generation targeted oncology sequencing assay. Oncotarget 2019 Mar 22;10(24):2384-2396. PMID: 31040929.',
          source_db_version:  '11-November-2018',
          source_type_id:     DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name:     'Tempus',
          full_name:          'Tempus xT',
          license:            'Supplementary data from CC-BY 3.0 Beaubier et al. copyright publication',
          license_link:       'https://www.oncotarget.com/article/26797/text/',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, TempusRow, source_info, header=true do
          gene :gene_symbol, nomenclature: 'Tempus Gene Symbol' do
            name :gene_symbol, nomenclature: 'Gene Symbol', transform: ->(x) { x.upcase }
            category 'ClINICALLY ACTIONABLE'
          end
        end.save!
      end
    end
  end
end
