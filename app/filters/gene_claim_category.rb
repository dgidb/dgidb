class GeneClaimCategory
  include Filter

  def initialize(category)
    @category = category
  end

  def cache_key
    "gene.category.#{@category}"
  end

  def axis
    :genes
  end

  def resolve
    Set.new DataModel::GeneClaimCategory.where(name: @category)
      .joins(gene_claims: [genes: [gene_claims: [:interaction_claims]]])
      .select("interaction_claims.id")
      .pluck('interaction_claims.id')
  end
end
