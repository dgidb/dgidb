class GeneCategorySearchResult

  attr_accessor :search_term, :genes, :unfiltered_genes

  def initialize(search_term, genes)
    @search_term = search_term
    @genes = genes.uniq
    @started_with_results = !!@genes.count
  end

  def is_ambiguous?
    @unfiltered_genes.count > 1
  end

  def has_results?
    @unfiltered_genes.count > 0
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

  def filter_genes
    @unfiltered_genes = @genes
    @genes = @genes.select{ |gene| yield gene }
  end

  def gene_categories
    return [] unless genes.count > 0
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
