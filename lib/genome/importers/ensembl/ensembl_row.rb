require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Ensembl
      class EnsemblRow < Genome::Importers::DelimitedRow
        attribute :ensembl_id
        attribute :ensembl_gene_symbol
        attribute :ensembl_gene_biotype

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end
