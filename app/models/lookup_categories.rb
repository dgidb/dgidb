class LookupCategories

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
        .select_all <<-EOS
          SELECT gcc.name, COUNT(gene_claim_id) FROM gene_claim_categories_gene_claims gccgc
          INNER JOIN gene_claim_categories gcc ON gcc.id = gccgc.gene_claim_category_id
          GROUP BY gcc.name ORDER BY COUNT(gene_claim_id) DESC;
        EOS
        .map{|x| OpenStruct.new(alternate_name: x.alternate_name, gene_count: x.gene_count, interaction_count: x.interaction_count )}
      Rails.cache.write("unique_category_names_with_counts", category_names, expires_in: 3.hours)
      category_names
    end
  end
end
