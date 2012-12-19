module DataModel
  class GeneClaimCategory < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::TypeEnumeration
    has_and_belongs_to_many :gene_claims

    def self.all_category_names
      key = 'all_gene_claim_category_names'
      unless Rails.cache.exist?(key)
        Rails.cache.write(key, self.pluck(:name).sort)
      end
      Rails.cache.fetch(key)
    end

    private
    def self.cache_key
      'all_gene_claim_categories'
    end

    def self.type_column
      :name
    end

    def self.transforms
      [:downcase, [:gsub, ' ', '_']]
    end
  end
end
