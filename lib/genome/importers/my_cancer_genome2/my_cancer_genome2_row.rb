require 'genome/importers/delimited_row'
module Genome
  module Importers
    module MyCancerGenome2
      class MyCancerGenome2Row < Genome::Importers::DelimitedRow
        attribute :primary_gene_name
        attribute :entrez_gene_name
        attribute :drug_name
        attribute :trade_name
        attribute :drug_class
        attribute :metadata_fda_approval

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end
