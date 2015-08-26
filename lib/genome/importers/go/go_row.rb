require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Go
      class GoRow < Genome::Importers::DelimitedRow
        attribute :uniprotkb_id
        attribute :gene_name
        attribute :gene_category
        attribute :description

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
