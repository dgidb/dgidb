module Genome
  module Importers
    module Talc
      def self.source_info
        {
            base_url: 'http://www.ncbi.nlm.nih.gov/gene?term=',
            site_url: 'https://www.ncbi.nlm.nih.gov/pubmed/24377743',
            citation: "A tabulated summary of targeted and biologic therapies for non-small-cell lung cancer. Simon GR, Somaiah N. Clin Lung Cancer. 2014 Jan;15(1):21-51. doi: 10.1016/j.cllc.2013.11.009. Epub 2013 Nov 21. PMID: 24377743",
            source_db_version:  '12-May-2016',
            source_type_id: DataModel::SourceType.INTERACTION,
            source_trust_level_id:  DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'TALC',
            full_name: 'Targeted Agents in Lung Cancer (Commentary, 2014)'
        }
      end

      def self.run(tsv_path)
        na_filter = ->(x) { x.upcase == 'N/A' || x.upcase == 'NA' }

        TSVImporter.import tsv_path, TalcRow, source_info do
          interaction known_action_type: 'unknown' do
            attribute :interaction_type, name: 'Interaction Type'

            gene :gene_target, nomenclature: 'Gene Symbol' do
              name :gene_target, nomenclature: 'Gene Symbol'
            end

            drug :drug_name, nomenclature: 'TALC', primary_name: :drug_name, transform: ->(x) { x.upcase } do
              name :drug_name, nomenclature: 'Primary Drug Name'
              name :drug_generic_name, nomenclature: 'Drug Generic Name', unless: na_filter
              names :drug_trade_name, nomenclature: 'Drug Trade Name', unless: na_filter
              names :drug_synonym, nomenclature: 'Drug Synonym', unless: na_filter
            end

            attribute :notes, name: 'Notes', unless: na_filter

          end
        end.save!
      end
    end
  end
end