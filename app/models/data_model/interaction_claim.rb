module DataModel
  class InteractionClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_many :interaction_claim_attributes, inverse_of: :interaction_claim
    belongs_to :gene_claim, inverse_of: :interaction_claims
    belongs_to :drug_claim, inverse_of: :interaction_claims
    belongs_to :source, inverse_of: :interaction_claims
    has_and_belongs_to_many :interaction_claim_types
  end
end
