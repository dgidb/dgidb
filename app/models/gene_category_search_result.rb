class GeneCategorySearchResult

  attr_accessor :search_term, :genes

  def initialize(search_term, genes)
    @search_term = search_term
    @genes = genes.uniq
    @categories = genes.flat_map { |g| g.gene_claims }
                    .flat_map { |gc| gc.gene_claim_categories }
                    .uniq
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

  def filter_categories
    @filtered_categories = @categories.select { |c| yield c }
  end

  def gene_categories
    (@filtered_categories || @categories).map { |c| c.name }
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
