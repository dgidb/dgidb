module DataModel
  class InteractionClaimType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::EnumerableType
    include Genome::Extensions::HasCacheableQuery

    has_and_belongs_to_many :interaction_claims, :join_table => 'interaction_claim_types_interaction_claims'

    cache_query :all_type_names, :all_interaction_type_names

    def self.all_type_names
      pluck(:type).sort
    end

    private
    def self.enumerable_cache_key
      'all_interaction_claim_types'
    end
  end
end
