require 'genome/importers/dsl/node'
require 'genome/importers/dsl/with_drugs_and_genes'
module Genome
  module Importers
    module DSL
      class InteractionNode < Node
        include Genome::Importers::DSL::WithDrugsAndGenes

        def create_interaction(opts)
          raise 'Interactions must link a gene and a drug!' unless @gene_claim_id && @drug_claim_id
          known_action_type = get_val(opts[:known_action_type], opts)
          @importer.create_interaction_claim(id: @id,
                                             drug_claim_id: @drug_claim_id,
                                             gene_claim_id: @gene_claim_id,
                                             known_action_type: known_action_type)
        end
      end
    end
  end
end
