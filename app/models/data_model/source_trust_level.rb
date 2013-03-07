module DataModel
  class SourceTrustLevel < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery
    has_many :sources, inverse_of: :source_trust_level

    cache_query :all_trust_levels, :all_source_trust_levels

    def self.all_trust_levels
      pluck(:level).sort
    end
  end
end
