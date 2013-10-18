module DataModel
  class InteractionClaimAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :interaction_claim, inverse_of: :interaction_claim_attributes
  end
end
