module DataModel
  class SourceType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::EnumerableType
    has_many :sources, inverse_of: :source_type

    private
    def self.enumerable_cache_key
      'all_source_types'
    end
  end
end
