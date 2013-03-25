class GeneClaimCategory
  include Filter

  def initialize(category)
    @category = category.downcase
  end

  def cache_key
    "gene_claim_category.#{@category}"
  end

  def axis
    :gene_categories
  end

  def resolve
    Set.new DataModel::GeneClaim
      .joins(:gene_claim_categories)
      .where('lower(gene_claim_categories.name) = ?', @category)
      .pluck('gene_claims.id')
      .uniq
  end
end
