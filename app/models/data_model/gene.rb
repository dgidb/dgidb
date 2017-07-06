module DataModel
  class Gene < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_many :gene_claims
    has_many :gene_gene_interaction_claims, inverse_of: :gene
    has_many :interactions
    has_many :gene_aliases
    has_many :gene_attributes
    has_and_belongs_to_many :gene_categories,
      :join_table => 'gene_categories_genes',
      :class_name => 'GeneClaimCategory'

    cache_query :all_gene_names, :all_gene_names

    def self.for_search
      # eager_load(gene_claims: {interaction_claims: { source: [], drug_claim: [:source], interaction_claim_types: [], gene_claim: [gene: [gene_claims: [:gene_claim_categories]]]}})
      includes(interactions: [:drug, :interaction_types, :publications, :sources])
    end

    def self.for_gene_categories
      eager_load(gene_claims: [:source, :gene_claim_categories])
    end

    def self.all_gene_names
      pluck(:name).sort
    end

    def self.for_show
      eager_load(gene_claims: [:gene_claim_aliases, :gene_claim_attributes, :gene, source: [:source_type]])
    end

  end
end
