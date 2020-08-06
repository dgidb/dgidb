  module Genome
    module Importers
      module ClearityFoundationClinicalTrial

        def self.source_info
          {
              base_url: 'https://www.clearityfoundation.org/form/findtrials.aspx',
              citation: 'https://www.clearityfoundation.org/form/findtrials.aspx',
              site_url: 'https://www.clearityfoundation.org/form/findtrials.aspx',
              source_db_version: '15-June-2013',
              source_type_id: DataModel::SourceType.INTERACTION,
              source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
              source_db_name: 'ClearityFoundationClinicalTrial',
              full_name: 'Clearity Foundation Clinical Trial',
          }
        end

        def self.run(tsv_path)
          blank_filter = ->(x) { x.blank? || x.upcase == 'N/A' || x.upcase == 'NA' }
          upcase = ->(x) { x.upcase }
          TSVImporter.import tsv_path, ClearityFoundationClinicalTrialRow, source_info do
            interaction known_action_type: :interaction_type do
              gene :entrez_gene_name, nomenclature: 'Gene Target Symbol', transform: upcase do
                name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
                attribute :molecular_target, name: 'Reported Genome Event Targeted'
              end

              drug :pubchem_name, nomenclature: 'Primary Drug Name', primary_name: :pubchem_name, transform: upcase do
                name :drug_name, nomenclature: 'Drug Trade Name', unless: blank_filter
                name :cid, nomenclature: 'PubChem Drug ID', unless: blank_filter
                name :sid, nomenclature: 'Pubchem Drug SID', unless: blank_filter
                names :other_drug_names, nomenclature: 'Other Drug Name', unless: blank_filter
                attribute :clinical_trial_id, name: 'Clinical Trial ID'

              end

              attribute :mode_of_action, name: 'Mechanism of Interaction'
            end
          end.save!
          s = DataModel::Source.find_by(source_db_name: source_info['source_db_name'])
          s.interaction_claims.each do |ic|
            Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Source TSV', File.join('data', 'source_tsvs', 'ClearityFoundationClinicalTrials_INTERACTIONS.tsv'))
          end
        end
      end
    end
  end
