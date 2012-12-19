module DataModel
  class GeneClaimCategory < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::EnumerableType
    include Genome::Extensions::HasCacheableQuery
    has_and_belongs_to_many :gene_claims

    cache_query :all_category_names, :all_gene_claim_category_names

    def self.all_category_names
      pluck(:name).sort
    end

    private
    def self.enumerable_cache_key
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
