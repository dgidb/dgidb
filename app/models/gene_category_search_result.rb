class GeneCategorySearchResult

  attr_accessor :search_term, :genes

  def initialize(search_term, genes)
    @search_term = search_term
    @genes = genes.uniq
  end

  def is_ambiguous?
    genes.length > 1
  end

  def has_results?
    genes.length > 0
  end

  def gene_group_name
    genes.first.name
  end

  def gene_group_display_name
    genes.first.long_name
  end

  def gene_categories
    genes.first.gene_claims
      .flat_map { |gc| gc.gene_claim_categories }
      .map { |gcc| gcc.name } || []
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
