require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Go
      class GoRow < Genome::Importers::DelimitedRow
        attribute :gene_name
        attribute :uniprot_ids, Array, delimiter: '|'
        attribute :gene_category

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
