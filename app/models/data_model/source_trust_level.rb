module DataModel
  class SourceTrustLevel < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery
    include Genome::Extensions::EnumerableType
    has_many :sources, inverse_of: :source_trust_level

    cache_query :all_trust_levels, 'all_source_trust_levels'

    def self.all_trust_levels
      pluck(:level).sort
    end

    private
    def self.enumerable_cache_key
      'all_source_trust_levels_enumeration'
    end

    def self.type_column
      :level
    end

    def self.transforms
      [:downcase, [:gsub, ' ', '_'], [:gsub, '-', '_']]
    end


  end
end
