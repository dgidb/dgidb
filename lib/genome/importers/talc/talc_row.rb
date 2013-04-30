require 'genome/importers/delimited_row'
module Genome
  module Importers
    module TALC
      class TALCRow < Genome::Importers::DelimitedRow
        attribute :interaction_id
        attribute :gene_target
        attribute :drug_name
        attribute :interaction_type
        attribute :drug_class
        attribute :drug_type
        attribute :drug_generic_name
        attribute :drug_trade_name, Array, delimiter: ','
        attribute :drug_synonym, Array, delimiter: ','
        attribute :entrez_id
        attribute :drug_cas_number
        attribute :drug_drugbank_id

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
