require 'genome/importers/delimited_row'
module Genome
  module Importers
    module BaderLab
      class BaderLabRow < Genome::Importers::DelimitedRow
        attribute :initial_gene_query
        attribute :primary_name
        attribute :entrez_gene_id
        attribute :citations
        attribute :gene_category
      end
    end
  end
end
