require 'genome/importers/delimited_row'
module Genome
  module Importers
    module FoundationOneGenes
      class FoundationOneGenesRow < Genome::Importers::DelimitedRow
        attribute :reported_gene_name
        attribute :entrez_gene_name
        attribute :entrez_gene_id
        attribute :gene_category
      end
    end
  end
end
