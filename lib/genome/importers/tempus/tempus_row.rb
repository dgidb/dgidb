require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Tempus
      class TempusRow < Genome::Importers::DelimitedRow
        attribute :gene_symbol
        
        def valid?(opts = {})
          true
        end
      end
    end
  end
end
# Edit for tempus xt
