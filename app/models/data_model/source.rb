module DataModel
  class Source < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_many :gene_claims, inverse_of: :source, dependent: :delete_all
    has_many :drug_claims, inverse_of: :source, dependent: :delete_all
    has_many :interaction_claims, inverse_of: :source, dependent: :delete_all
    belongs_to :source_type, inverse_of: :sources
    belongs_to :source_trust_level, inverse_of: :sources

    cache_query :source_names_with_interactions, :all_source_names_with_interactions
    cache_query :potentially_druggable_sources, :all_potenially_druggable_sources
    cache_query :source_names_with_gene_claims, :source_names_with_gene_claims

    def self.potentially_druggable_sources
      #return source entries for druggable gene sources that aren't Entrez
      #or Ensembl, have genes, and have no interactions
      where(source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE).all
    end

    def self.source_names_with_interactions
      where(source_type_id: DataModel::SourceType.INTERACTION)
        .pluck(:source_db_name)
        .sort
    end

    def self.source_names_with_gene_claims
      joins(:gene_claims)
        .uniq
        .pluck(:source_db_name)
        .sort_by { |name| GeneClaimSortOrder.sort_value(name) }
    end

  end
end
