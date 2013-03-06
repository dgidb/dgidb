module DataModel
  class SourceTrustLevel < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::EnumerableType
    has_many :sources, inverse_of: :source_trust_level

    private
    def self.enumerable_cache_key
      'all_source_trust_levels'
    end

    def self.type_column
      :level
    end
  end
end
