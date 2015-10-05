require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Chembl
      class ChemblRow < Genome::Importers::DelimitedRow
        attribute :drug_chembl_id
        attribute :drug_name
        attribute :gene_chembl_id
        attribute :gene_symbol, Array, delimiter: '|'
        attribute :uniprot_id, Array, delimiter: '|'
        attribute :uniprot_name, Array, delimiter: '|'
        attribute :action_type
        attribute :mechanism_of_action
        attribute :direct_interaction
        attribute :fda, Array, delimiter: '|'
        attribute :pmid, Array, delimiter: '|'
        attribute :tax_id

        def valid?(opts = {})
          tax_id == '9606'
        end
      end
    end
  end
end