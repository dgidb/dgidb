require 'genome/importers/delimited_row'
module Genome
  module Importers
    module CarisMolecularIntelligence
      class CarisMolecularIntelligenceRow < Genome::Importers::DelimitedRow
        attribute :gene_symbol
        
        def valid?(opts = {})
          true
        end
      end
    end
  end
end
