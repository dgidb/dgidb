class DataSources

  include Genome::Extensions::HasCacheableQuery

  cache_query :uniq_source_names_with_gene_claims, :uniq_source_names_with_gene_claims
  cache_query :uniq_source_names, :all_uniq_source_names
  cache_query :all_source_summaries, :all_source_summaries

  def self.uniq_source_names_with_gene_claims
    uniq_source_names_with_table(:gene_claims)
  end

  def self.gene_sources_in_display_order
    uniq_source_names_with_gene_claims.sort_by do |source_db_name|
      GeneClaimSortOrder.sort_value(source_db_name)
    end
  end

  def self.uniq_source_names
    DataModel::Source.uniq.pluck(:source_db_name)
  end

  private
  def self.uniq_source_names_with_table(relation_name)
    DataModel::Source.joins(relation_name.to_sym).uniq.pluck(:source_db_name)
  end

end
