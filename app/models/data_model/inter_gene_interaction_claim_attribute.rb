module DataModel
  class InterGeneInteractionClaimAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :inter_gene_interaction_claim, inverse_of: :attributes
  end
end
