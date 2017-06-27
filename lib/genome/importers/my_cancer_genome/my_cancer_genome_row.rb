require 'genome/importers/delimited_row'
module Genome
  module Importers
    module MyCancerGenome
      class MyCancerGenomeRow < Genome::Importers::DelimitedRow
        attribute :drug_name
        attribute :drug_trade_name, Array
        attribute :drug_class
        attribute :gene_symbol
        attribute :reported_gene_name
        attribute :metadata_fda_approval
        attribute :entrez_gene_id
        attribute :drug_development_name, Array
        attribute :drug_generic_name, Array
        attribute :notes
        attribute :interaction_type

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
