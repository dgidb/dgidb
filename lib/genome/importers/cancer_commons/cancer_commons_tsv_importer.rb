module Genome
  module Importers
    module CancerCommons

      def self.source_info
        {
          base_url: 'http://www.cancercommons.org/researchers-clinicians/',
          site_url: 'http://www.cancercommons.org/',
          citation: 'Cancer Commons: Biomedicine in the Internet Age. Shrager J, Tenenbaum JM, and Travers M. Collaborative Computational Technologies for Biomedical Research, (Sean Elkins, Maggie Hupcey, and Antony Williams Eds). Wiley, 2010.',
          source_db_version: 'Dec-22-2012',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name: 'CancerCommons',
          full_name: 'Cancer Commons',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, CancerCommonsRow, source_info do
          interaction known_action_type: 'unknown' do
            gene :primary_gene_name, nomenclature: 'Gene Target Symbol' do
              name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
              names :reported_gene_names, nomenclature: 'CancerCommons Reported Gene Name'
            end

            drug :primary_drug_name, nomenclature: 'Primary Drug Name', primary_name: :primary_drug_name do
              attribute :drug_class, name: 'Drug Class' 
              name :pubchem_drug_name, nomenclature: 'PubChem Drug Name'
              name :pubchem_drug_id, nomenclature: 'PubChem Drug ID'
              attribute :source_reported_drug_name, name: 'Source Reported Drug Name(s)'
              name :drug_trade_name, nomenclature: 'Drug Trade Name'
              name :drug_development_name, nomenclature: 'Drug Development Name'
              attribute :pharmaceutical_developer, name: 'Pharmaceutical Developer'
            end

            attribute :interaction_type, name: 'Interaction Type'
            attribute :cancer_type, name: 'Reported Cancer Type'
          end
        end.save!
      end
    end
  end
end
