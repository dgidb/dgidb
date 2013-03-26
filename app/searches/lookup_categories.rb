class LookupCategories
  extend FilterHelper

  def self.find(params)
    gene_results = LookupGenes.find(
      params[:gene_names],
      :for_gene_categories,
      GeneCategorySearchResult
    )

    filter_results(gene_results, params)
  end

  #given a category name this method will return a list of genes
  def self.find_genes_for_category(category_name)
    DataModel::Gene.joins(gene_claims: [:gene_claim_categories, :source])
       .eager_load(gene_claims: [source: [:source_trust_level]])
       .where('gene_claim_categories.name' => category_name)
       .uniq
  end

  def self.get_uniq_category_names_with_counts
    Rails.cache.fetch('unique_category_names_with_counts') do
      categories_with_counts = DataModel::GeneClaimCategory
        .connection
        .select_all(<<-EOS
          SELECT gcc.name, COUNT(DISTINCT(gcg.gene_id)) FROM gene_claim_categories_gene_claims gccgc
          INNER JOIN gene_claim_categories gcc ON gcc.id = gccgc.gene_claim_category_id
          INNER JOIN gene_claims_genes gcg ON gcg.gene_claim_id = gccgc.gene_claim_id
          GROUP BY gcc.name ORDER BY gcc.name ASC;
        EOS
        ).map { |x| OpenStruct.new(name: x['name'], gene_count: x['count']) }
      categories_with_counts
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
