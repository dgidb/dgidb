require 'genome/importers/dsl/node'
module Genome
  module Importers
    module DSL
      class GeneNode < Node
        def initialize(item_id, importer_instance, row_instance)
          super(item_id, importer_instance, row_instance, 'gene_claim')
        end
      end
    end
  end
end
