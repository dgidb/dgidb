module DataModel
  class GeneGeneInteractionClaimAttribute < ::ActiveRecord::Base
    belongs_to :gene_gene_interaction_claim, inverse_of: :attributes
  end
end
