module Genome
  module Importers
    module ClearityFoundationClinical

      def self.source_info
        {
            base_url: 'https://www.clearityfoundation.org/form/findtrials.aspx',
            citation: 'https://www.clearityfoundation.org/form/findtrials.aspx',
            site_url: 'https://www.clearityfoundation.org/form/findtrials.aspx',
            source_db_version: '15-June-2013',
            source_type_id: DataModel::SourceType.INTERACTION,
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'ClearityFoundationClinicalTrials',
            full_name: 'Clearity Foundation Clinical Trials',
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? }
        upcase = ->(x) { x.upcase }
        TSVImporter.import tsv_path, ClearityClinicalRow, source_info do
          interaction known_action_type: 'unknown' do
            gene :entrez_gene_name, nomenclature: 'Entrez Gene Name', transform: upcase do
              name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
              name :molecular_target, nomenclature: 'Reported Gene Name'
            end

            drug :pubchem_name, nomenclature: 'Primary Drug Name', primary_name: :pubchem_name, transform: upcase do
              attribute :drug_class, name: 'Drug Class'
              name :drug__name, nomenclature: 'Drug Trade Name', unless: blank_filter
              name :CID, nomenclature: 'PubChem Drug CID', unless: blank_filter
              name :SID, nomenclature: 'Pubchem Substance SID', unless: blank_filter
              name :other_drug_name, nomenclature: 'Other Drug Name', unless: blank_filter
              attribute :clinical_trial_ID, name: 'Clinical Trial ID'
            end
            attribute :interaction_type, name: 'Interaction Type'
            attribute :mode_of_action, name: 'Mechanism of Interaction'
            attribute :clinical_trial_ID, name: 'Clinical Trial ID'
          end
        end.save!
      end
    end
  end
end

