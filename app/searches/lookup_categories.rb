class LookupCategories

  def self.find(params)
    gene_results = LookupGenes.find(
      params[:gene_names],
      :for_gene_categories,
      GeneCategorySearchResult
    )

    filter_scope = FilterChain.new

    params[:gene_categories].each do |category|
      filter_scope.include_gene_claim_category(category)
    end

    gene_results.each do |result|
      result.filter_categories do |gene_claim|
        filter_scope.include?(gene_claim.id)
      end
    end

    gene_results
  end

  #given a category name this method will return a list of genes
  def self.find_genes_for_category(category_name)
    DataModel::Gene.joins(gene_claims: [:gene_claim_categories, :source])
       .eager_load(gene_claims: [:source])
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
end
