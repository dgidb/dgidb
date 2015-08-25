require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Entrez
      class EntrezRow < Genome::Importers::DelimitedRow
        attribute :entrez_id
        attribute :entrez_gene_symbol
        attribute :entrez_gene_synonyms, Array, delimiter: '|'
        attribute :ensembl_ids, Array, delimiter: '|'
        attribute :description

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end
