module Genome
  module Importers
    module TEND
      def source_info
        {
          base_url:          'http://www.uniprot.org/uniprot/',
          site_url:          'http://www.ncbi.nlm.nih.gov/pubmed/21804595/',
          citation:          "Trends in the exploitation of novel drug targets. Rask-Andersen M, Almen MS, Schioth HB. Nat Rev Drug Discov. 2011 Aug 1;10(8):579-90. PMID: 21804595",
          source_db_version:  '01-Aug-2011',
          source_type_id:    DataModel::SourceType.INTERACTION,
          source_db_name:    'TEND',
          full_name:         'Trends in the exploitation of novel drug targets (Rask-Andersen, et al., 2011)',
          license: 'Supplementary table from Macmillan Publishers Limited copyright publication',
          license_link: 'https://www.nature.com/articles/nrd3478',
        }
      end

      def self.run(tsv_path)
        na_filter = ->(x) {x.upcase = 'N/A'}
        TSVImporter.import tsv_path, TENDRow, source_info do
          interaction known_action_type: 'unknown' do
            attribute 'n/a', name: 'Interaction Type'

            gene :uniprot_id, nomenclature: 'Uniprot Accession' do
              name :uniprot_id, nomenclature: 'Uniprot Accession'
              name :gene_symbol, nomenclature: 'Gene Symbol', unless: na_filter
              name :entrez_id, nomenclature: 'Entrez Gene Id', unless: na_filter
              name :ensembl_id, nomenclature: 'Ensembl Gene Id', unless: na_filter
              name :uniprot_accession_number, nomenclature: 'Uniprot Id', unless: na_filter
              attributes :target_main_class, nomenclature: 'Target Main Class', unless: na_filter
              attributes :target_subclass, nomenclature: 'Target Subclass', unless: na_filter
              attribute :number_transmembrane_helices, nomenclature: 'Transmembrane Helix Count', unless: na_filter
            end

            drug :drug_name, nomenclature: 'TEND' do
              name :drug_name, nomenclature: 'Primary Drug Name'
              attributes :indication, name: 'Drug Class', unless: na_filter
              attribute :year_of_approval, name: 'Year of Approval', unless: na_filter
            end
          end
        end
        s = DataModel::Source.where(source_db_name: source_info['source_db_name'])
        DataModel::InteractionClaim.where(source_id: s.id).each do |ic|
          Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Trends in the exploitation of novel drug targets, Table 1', "https://www.nature.com/articles/nrd3478/tables/1")
        end
      end
    end
  end
end
