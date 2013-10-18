module DataModel
  class DrugClaimAlias < ::ActiveRecord::Base
    belongs_to :drug_claim, inverse_of: :drug_claim_aliases
  end
end
