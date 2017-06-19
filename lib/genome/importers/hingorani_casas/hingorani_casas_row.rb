require 'genome/importers/delimited_row'
module Genome
  module Importers
    module HingoraniCasas
      class HingoraniCasasRow < Genome::Importers::DelimitedRow
        attribute :gene_symbol
        attribute :ensembl_id

        def valid?(opts = {})
          true
        end
      end
    end
  end
end