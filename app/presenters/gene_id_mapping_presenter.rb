class GeneIdMappingPresenter
  attr_reader :search_term
  def initialize(gene_claim, search_term)
    @gene_claim = gene_claim
    @search_term = search_term
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

end
