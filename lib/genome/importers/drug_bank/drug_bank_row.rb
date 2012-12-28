require 'genome/importers/delimited_row'
module Genome
  module Importers
    module DrugBank
      class DrugBankRow < Genome::Importers::DelimitedRow
        attribute :count
        attribute :drug_id
        attribute :drug_name
        attribute :drug_synonyms, Array
        attribute :drug_cas_number
        attribute :drug_brands, Array
        attribute :drug_type
        attribute :drug_groups, Array
        attribute :drug_categories, Array
        attribute :gene_id
        attribute :known_action
        attribute :target_actions, Array
        attribute :gene_symbol
        attribute :uniprot_id
        attribute :entrez_id
        attribute :ensembl_id

        def valid?(opts = {})
          return false if uniprot_id == 'N/A' && gene_symbol == 'N/A'
          return false unless opts[:uniprot_mapping][uniprot_id]
          true
        end
      end
    end
  end
end
