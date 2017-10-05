class LookupCategories
  extend FilterHelper
  CategoryResultWithCount = Struct.new(:name, :gene_count)

  def self.find(params)
    gene_results = LookupGenes.find(
      params[:gene_names],
      :for_gene_categories,
      GeneCategorySearchResult
    )

    filter_results(gene_results, params)
  end

  def self.gene_names_in_category(category_name)
    DataModel::GeneClaimCategory
      .joins(:genes)
      .where(name: category_name.upcase)
      .order('genes.name')
      .pluck('genes.name')
      .uniq
  end

  def self.find_genes_for_category_and_sources(category_name, source_names)
    DataModel::Gene.joins(gene_claims: [:gene_claim_categories, :source])
       .eager_load(gene_claims: [source: [:source_trust_level]])
       .where('lower(gene_claim_categories.name) = ?', category_name.downcase)
       .where('lower(sources.source_db_name) IN (?)', source_names.map(&:downcase))
       .uniq
  end

  def self.get_category_names_with_counts_in_sources(sources)
    sources = Array(sources)
    Rails.cache.fetch("unique_category_names_with_counts_#{sources}") do
      DataModel::GeneClaimCategory.joins(gene_claims: [:gene, :source])
        .where('sources.source_db_name' => sources)
        .group('gene_claim_categories.name')
        .order('gene_claim_categories.name ASC')
        .select('COUNT(DISTINCT(gene_claims.gene_id)) as gene_count, gene_claim_categories.name')
        .map { |x| CategoryResultWithCount.new(x.name, x.gene_count) }
    end
  end

  private
  def self.filter_results(gene_results, params)
    gene_claim_filter_scope = construct_filter(PARAM_KEY_TO_GENE_CLAIM_FILTER_MAP, params)
    category_filter_scope = construct_filter(PARAM_KEY_TO_CATEGORY_FILTER_MAP, params)

    gene_results.each do |result|
      result.filter_gene_claims do |gene_claim|
        gene_claim_filter_scope.include?(gene_claim.id)
      end

      result.filter_categories do |gene_claim_category|
        category_filter_scope.include?(gene_claim_category.id)
      end
    end
    gene_results
  end

  PARAM_KEY_TO_GENE_CLAIM_FILTER_MAP = {
    category_sources: :include_category_source_db_name,
    source_trust_levels: :include_category_source_trust_level,
  }

  PARAM_KEY_TO_CATEGORY_FILTER_MAP = {
    gene_categories: :include_gene_claim_category
  }
end
