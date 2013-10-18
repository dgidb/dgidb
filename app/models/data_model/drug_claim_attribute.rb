module DataModel
  class DrugClaimAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :drug_claim, inverse_of: :drug_claim_attributes
  end
end
