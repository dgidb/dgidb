require 'genome/importers/dsl/with_drugs_and_genes'
module Genome
  module Importers
    module DSL
      class Importer
        include Genome::Importers::DSL::WithDrugsAndGenes

        attr_accessor :row

        def interaction(opts = {}, &block)
          opts = @defaults.merge opts
          interaction_claim_id = SecureRandom.uuid
          node = InteractionNode.new(interaction_claim_id, @importer, @row)
          node.instance_eval(&block)
          node.create_interaction(opts[:known_action_type] || 'unknown')
        end

        def save!
          res = @importer.store
          puts res.map { |(entity, num)| "Imported #{num} #{entity}." }.join("\n")
        end

        def initialize(source_info)
          @importer = Genome::Importers::Importer.new(source_info)
          @defaults = { transform: ->(x) { x }, unless: ->(x) { false } }
        end
      end
    end
  end
end
