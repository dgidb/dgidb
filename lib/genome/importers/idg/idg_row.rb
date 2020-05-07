require 'genome/importers/delimited_row'
module Genome
  module Importers
    module IDG
      class IDGRow < Genome::Importers::DelimitedRow
        attribute :gene_symbol
	attribute :gene_category
        
        def valid?(opts = {})
          true
        end
      end
    end
  end
end
