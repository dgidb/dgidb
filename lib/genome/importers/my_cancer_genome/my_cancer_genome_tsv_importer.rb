module Genome
  module Importers
    module MyCancerGenome

      def self.source_info
        {
          base_url: 'https://www.mycancergenome.org/content/molecular-medicine/overview-of-targeted-therapies-for-cancer/',
          site_url: 'http://www.mycancergenome.org/',
          citation: 'Abramson, R., Aston, J., C. Lovly. 2017. My Cancer Genome.',
          source_db_version: '20-Jun-2017',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_db_name: 'MyCancerGenome',
          full_name: 'My Cancer Genome',
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          license: 'Restrictive, custom, non-commercial',
          license_url: 'https://www.mycancergenome.org/content/page/legal-policies-licensing/',
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? }
        TSVImporter.import tsv_path, MyCancerGenomeRow, source_info do
          interaction known_action_type: 'unknown' do
            drug :drug_name, nomenclature: 'MyCancerGenome Drug Name', primary_name: :drug_name, transform: ->(x) { x.upcase } do
              attribute :drug_class, name: 'Drug Class', unless: blank_filter
              attribute :notes, name: 'Notes', unless: blank_filter
              attribute :metadata_fda_approval, name: 'FDA Approval', unless: blank_filter
              names :drug_development_name, nomenclature: 'Development Name', transform: ->(x) { x.upcase }, unless: blank_filter
              names :drug_generic_name, nomenclature: 'Generic Name', transform: ->(x) { x.upcase }, unless: blank_filter
              names :drug_trade_name, nomenclature: 'Trade Name', transform: ->(x) { x.upcase }, unless: blank_filter
            end
            gene :gene_symbol, nomenclature: 'MyCancerGenome Gene Symbol' do
              name :entrez_gene_id, nomenclature: 'Entrez Gene Id', unless: blank_filter
              name :gene_symbol, nomenclature: 'MyCancerGenome Gene Symbol', unless: blank_filter
              name :reported_gene_name, nomenclature: 'MyCancerGenome Reported Gene Name', unless: blank_filter
            end

            attribute :interaction_type, name: 'Interaction Type', unless: blank_filter
          end
        end.save!
        s = DataModel::Source.where(source_db_name: source_info['source_db_name'])
        s.interaction_claims.each do |ic|
          Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Overview of Targeted Therapies for Cancer', "https://www.mycancergenome.org/content/page/overview-of-targeted-therapies-for-cancer/")
        end
      end
    end
  end
end

