require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Civic
      class CivicRow < Genome::Importers::DelimitedRow
        attribute :civic_id
        attribute :gene_symbol
        attribute :drug_name
        attribute :entrez_gene_id
        attribute :interaction_type
        attribute :pmid, Array, delimiter: ','

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end
