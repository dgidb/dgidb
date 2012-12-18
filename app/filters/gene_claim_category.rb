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
      .joins(gene_claims: [:genes])
      .select('genes.id')
      .pluck('genes.id')
      .uniq
  end
end
