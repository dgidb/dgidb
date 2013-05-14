require 'genome/importers/delimited_row'
module Genome
  module Importers
    module RussLampel
      class RussLampelRow < Genome::Importers::DelimitedRow
        attribute :gene_stable_id
        attribute :display_id
        attribute :description
        attribute :HumanReadableName, parser: ->(val){val.gsub!('-', ' ') == 'RussLampel' ? 'Druggable Genome' : val}
        
        def valid?(opts = {})
          true
        end
      end
    end
  end
end
