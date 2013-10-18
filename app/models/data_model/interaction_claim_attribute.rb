module DataModel
  class InteractionClaimAttribute < ::ActiveRecord::Base
    belongs_to :interaction_claim, inverse_of: :interaction_claim_attributes
  end
end
