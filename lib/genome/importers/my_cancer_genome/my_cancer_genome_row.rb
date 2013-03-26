require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Entrez
      class MyCancerGenomeRow < Genome::Importers::DelimitedRow
        attribute :gene_symbol
        attribute :entrez_gene_id
        attribute :reported_gene_name
        attribute :primary_drug_name
        attribute :drug_development_name, Array
        attribute :drug_generic_name, Array
        attribute :drug_trade_name, Array
        attribute :notes
        attribute :drug_class
        attribute :interaction_type

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end
