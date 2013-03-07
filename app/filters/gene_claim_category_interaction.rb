class GeneClaimCategoryInteraction
  include Filter

  def initialize(category)
    @category = category.downcase
  end

  def cache_key
    "gene.category.interactions.#{@category}"
  end

  def axis
    :genes
  end

  def resolve
    Set.new DataModel::GeneClaimCategory
      .where('lower(gene_claim_categories.name) = ?', @category)
      .joins(gene_claims: [genes: [gene_claims: [:interaction_claims]]])
      .select("interaction_claims.id")
      .pluck('interaction_claims.id')
  end
end
