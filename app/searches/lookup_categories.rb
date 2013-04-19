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

  def self.find_genes_for_category_and_sources(category_name, source_names)
    DataModel::Gene.joins(gene_claims: [:gene_claim_categories, :source])
       .eager_load(gene_claims: [source: [:source_trust_level]])
       .where('gene_claim_categories.name' => category_name)
       .where('sources.source_db_name' => source_names)
       .uniq
  end

  def self.get_category_names_with_counts_in_sources(sources)
    sources = Array(sources)
    Rails.cache.fetch("unique_category_names_with_counts_#{sources}") do
      DataModel::GeneClaimCategory.joins(gene_claims: [:genes, :source])
        .where('sources.source_db_name' => sources)
        .group('gene_claim_categories.name')
        .order('gene_claim_categories.name ASC')
        .select('COUNT(DISTINCT(genes.id)) as gene_count, gene_claim_categories.name')
        .map { |x| CategoryResultWithCount.new(x.name, x.gene_count) }
    end
  end

  private

  def self.filter_results(gene_results, params)
    gene_claim_filter_scope = FilterChain.new
    category_filter_scope = FilterChain.new

    construct_filter(gene_claim_filter_scope, params[:sources], :include_category_source_db_name)
    construct_filter(gene_claim_filter_scope, params[:source_trust_levels], :include_category_source_trust_level)
    construct_filter(category_filter_scope, params[:gene_categories], :include_gene_claim_category)

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
end
