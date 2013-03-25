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
    Set.new DataModel::GeneClaimCategory
      .joins(:gene_claims)
      .where('lower(gene_claim_categories.name) = ?', @category)
      .pluck('gene_claim_id')
      .uniq
  end
end
