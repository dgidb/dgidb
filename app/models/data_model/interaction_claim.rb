module DataModel
  class InteractionClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :gene_claim, inverse_of: :interaction_claims
    belongs_to :drug_claim, inverse_of: :interaction_claims
    belongs_to :source, inverse_of: :interaction_claims
    has_many :interaction_claim_attributes, inverse_of: :interaction_claim

  end
end
