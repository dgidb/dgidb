require 'genome/importers/dsl/node'
module Genome
  module Importers
    module DSL
      class DrugNode < Node
        def initialize(item_id, importer_instance, row_instance)
          super(item_id, importer_instance, row_instance, 'drug_claim')
        end
      end
    end
  end
end
