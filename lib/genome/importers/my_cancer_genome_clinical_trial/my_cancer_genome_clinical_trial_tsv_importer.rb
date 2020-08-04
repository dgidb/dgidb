  module Genome
    module Importers
      module MyCancerGenomeClinicalTrial
        def self.source_info
          {
              base_url: 'http://www.mycancergenome.org/',
              citation: 'http://www.mycancergenome.org/',
              site_url: 'http://www.mycancergenome.org/',
              source_db_version: '30-Feburary-2014',
              source_type_id: DataModel::SourceType.INTERACTION,
              source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
              source_db_name: 'MyCancerGenomeClinicalTrial',
              full_name: 'MyCancerGenome Clinical Trial',
              license: 'Restrictive, custom, non-commercial',
              license_url: 'https://www.mycancergenome.org/content/page/legal-policies-licensing/',
          }
        end

        def self.run(tsv_path)
          blank_filter = ->(x) { x.blank? }
          upcase = ->(x) { x.upcase }

          TSVImporter.import tsv_path, MyCancerGenomeClinicalTrialRow, source_info do
            interaction known_action_type: :interaction_type do
              attribute :interaction_type, name: 'Interaction Type'
              gene :entrez_gene_name, nomenclature: 'Gene Target Symbol', transform: upcase do
                name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
                attribute :molecular_target, name: 'Reported Genome Event Targeted'
              end

              drug :pubchem_name, nomenclature: 'Primary Drug Name', primary_name: :pubchem_name, transform: upcase do
                name :drug_name, nomenclature: 'Drug Trade Name', unless: blank_filter
                name :cid, nomenclature: 'PubChem Drug ID', unless: blank_filter
                names :other_drug_names, nomenclature: 'Other Drug Name', unless: blank_filter
              end

              attribute :clinical_trial_id, name: 'Clinical Trial ID'
              attribute :disease, name: 'Type of Cancer Targeted'
              attribute :indication_of_interaction, name: 'Indication of Interaction'
            end
          end.save!
          s = DataModel::Source.where(source_db_name: source_info['source_db_name'])
          s.interaction_claims.each do |ic|
            Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Clinical Trials', "https://www.mycancergenome.org/content/clinical_trials/")
          end
        end
      end
    end
  end
