module DataModel
  class SourceType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::TypeEnumeration
    has_many :sources, inverse_of: :source_type

    private
    def self.cache_key
      'all_source_types'
    end
  end
end
