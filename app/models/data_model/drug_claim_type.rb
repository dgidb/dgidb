module DataModel
  class DrugClaimType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::EnumerableType
    has_and_belongs_to_many :drug_claims

    private
    def self.enumerable_cache_key
      'all_drug_claim_types'
    end
  end
end