module DataModel
  class GeneGeneInteractionClaimAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :gene_gene_interaction_claim, inverse_of: :attributes
  end
end
