class GeneCategorySearchResult

  attr_accessor :search_term, :genes

  def initialize(search_terms, genes)
    @search_term = search_terms.join(", ")
    @search_terms = search_terms
    @genes = genes.uniq
  end

  def is_ambiguous?
    @genes.count > 1
  end

  def has_results?
    @genes.count > 0
  end

  def gene_name
    genes.first.name
  end

  def gene_display_name
    genes.first.long_name
  end

  def gene
    genes.first
  end

  def gene_claims
    @filtered_gene_claims || @genes.flat_map { |g| g.gene_claims }
  end

  def filter_categories
    @filtered_gene_claims = @genes.flat_map { |g| g.gene_claims }
                            .select { |gc| yield gc }

    @filtered_categories = @filtered_gene_claims
                            .flat_map { |gc| gc.gene_claim_categories }
                            .uniq
  end

  def gene_categories
    @filtered_categories.map { |c| c.name }
  end

  def partition
    if has_results?
      if is_ambiguous?
          :ambiguous
      else
          :definite
      end
    else
      :no_results
    end
  end

end
