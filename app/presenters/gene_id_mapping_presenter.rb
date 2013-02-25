class GeneIdMappingPresenter
  attr_reader :search_term
  def initialize(gene_claim, search_term)
    @gene_claim = gene_claim
    @search_term = search_term
  end

  def primary_name
    matched? ? gene.name : 'not matched'
  end

  def long_name
    matched? ? gene.long_name : 'not matched'
  end

  def match_status
    matched? ? 'matched' : 'not matched'
  end

  def matches
    if matched?
      @gene_claim.genes
        .first.gene_claims
        .map { |gc| [gc.nomenclature, gc.name] }
        .uniq
    else
      []
    end
  end

  private
  def matched?
    @gene_claim.genes.size == 1
  end

  def gene
    @gene_claim.genes.first
  end

end
