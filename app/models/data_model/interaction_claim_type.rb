module DataModel
  class InteractionClaimType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::TypeEnumeration
    has_and_belongs_to_many :interaction_claims

    def self.all_type_names
      key = 'all_type_names'
      unless Rails.cache.exist?(key)
        Rails.cache.write(key, self.pluck(:type).sort)
      end
      Rails.cache.fetch(key)
    end

    private
    def self.cache_key
      'all_interaction_claim_types'
    end
  end
end
