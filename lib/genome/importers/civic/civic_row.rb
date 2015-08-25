require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Civic
      class CivicRow < Genome::Importers::DelimitedRow
        attribute :civic_id
        attribute :gene_symbol
        attribute :entrez_gene_id
        attribute :drug_name
        attribute :interaction_type

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end
