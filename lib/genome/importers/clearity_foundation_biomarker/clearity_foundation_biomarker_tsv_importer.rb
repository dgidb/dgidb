module Genome
  module Importers
    module ClearityFoundationBiomarker

      def self.source_info
        {
          base_url: 'http://www.clearityfoundation.org/healthcare-pros/drugs-and-biomarkers.aspx',
          citation: 'http://www.clearityfoundation.org/healthcare-pros/drugs-and-biomarkers.aspx',
          site_url: 'https://www.clearityfoundation.org/healthcare-pros/drugs-and-biomarkers.aspx',
          source_db_version: '26-July-2013',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name: 'ClearityFoundationBiomarkers',
          full_name: 'Clearity Foundation Biomarkers',
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? }
        upcase = ->(x) { x.upcase }
        TSVImporter.import tsv_path, ClearityBiomarkerRow, source_info do
          interaction known_action_type: 'unknown' do
            gene :gene_name, nomenclature: 'Gene Target Symbol', transform: upcase do
              name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
              attribute :reported_gene_name, name: 'Reported Genome Event Targeted'
            end

            drug :drug_name, nomenclature: 'Primary Drug Name', primary_name: :drug_name, transform: upcase do
              attribute :drug_class, name: 'Drug Class'
              name :drug_trade_name, nomenclature: 'Drug Trade Name', unless: blank_filter
              name :pubchem_id, nomenclature: 'PubChem Drug ID'
              attribute :drug_subclass, name: 'Drug Classification'
              attribute :linked_class_info, name: 'Link to Clearity Drug Class Schematic'
            end
            attribute :interaction_type, name: 'Interaction Type'
            attribute :interaction_mechanism, name: 'Mechanism of Interaction'
          end
        end.save!
        s = DataModel::Source.find_by(source_db_name: source_info['source_db_name'])
        s.interaction_claims.each do |ic|
          Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Source TSV', File.join('data', 'source_tsvs', 'ClearityFoundation_INTERACTIONS.tsv'))
        end
      end
    end
  end
end

