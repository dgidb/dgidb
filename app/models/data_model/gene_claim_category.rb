module DataModel
  class GeneClaimCategory < ::ActiveRecord::Base
    include Genome::Extensions::EnumerableType
    include Genome::Extensions::HasCacheableQuery
    has_and_belongs_to_many :gene_claims

    cache_query :all_category_names, :all_gene_claim_category_names
    cache_query :categories_in_sources, :categories_in_sources

    def self.all_category_names
      pluck(:name).sort
    end

    #given an array of source_db_names, return an array
    #of gene_claim_category names in those sources
    def self.categories_in_sources(sources)
      joins(gene_claims: [:source])
      .where('sources.source_db_name' => sources)
      .pluck('gene_claim_categories.name')
      .uniq
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
