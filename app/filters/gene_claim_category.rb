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
      .where('lower(name) = ?', @category)
      .pluck('id')
      .uniq
  end
end
