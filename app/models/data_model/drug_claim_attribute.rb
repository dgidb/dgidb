module DataModel
  class DrugClaimAttribute < ::ActiveRecord::Base
    belongs_to :drug_claim, inverse_of: :drug_claim_attributes
  end
end
