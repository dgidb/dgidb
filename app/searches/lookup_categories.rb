class LookupCategories

  def self.find(params)
    gene_results = LookupGenes.find(
      params[:gene_names],
      :for_gene_categories,
      GeneCategorySearchResult
    )

    filter_scope = 
  end

  #given a list of (or single) category name(s) this method will return a hash
  #containing category names as keys, and the Genes in each category as values
  def self.find_genes_for_categories(category_names)
    categories = Array(category_names)
    raise "Please specify at least one category name" unless categories.size > 0

    categories_with_genes = DataModel::GeneClaimCategory.where(name: categories)
      .eager_load(gene_claims: [genes: [gene_claims: [:source]]])

    categories_with_genes.inject({}) do |hash, category|
      hash.tap do |h|
        hash[category.name] = category.gene_claims
          .flat_map { |claim| claim.genes }
          .uniq
      end
    end
  end

  def self.get_uniq_category_names_with_counts
    if Rails.cache.exist?("unique_category_names_with_counts")
      Rails.cache.fetch("unique_category_names_with_counts")
    else
      categories_with_counts = DataModel::GeneClaimCategory
        .connection
        .select_all(<<-EOS
          SELECT gcc.name, COUNT(DISTINCT(gcg.gene_id)) FROM gene_claim_categories_gene_claims gccgc
          INNER JOIN gene_claim_categories gcc ON gcc.id = gccgc.gene_claim_category_id
          INNER JOIN gene_claims_genes gcg ON gcg.gene_claim_id = gccgc.gene_claim_id
          GROUP BY gcc.name ORDER BY COUNT(DISTINCT(gcg.gene_id)) DESC;
        EOS
        ).map { |x| OpenStruct.new(name: x['name'], gene_count: x['count']) }
      Rails.cache.write("unique_category_names_with_counts", categories_with_counts, expires_in: 3.hours)
      categories_with_counts
    end
  end
end
