class ClinicallyActionable
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "clinically_actionable"
  end

  def axis
    :clinically_actionable
  end

  def resolve
    category_id = DataModel::GeneClaimCategory.where(name: 'CLINICALLY ACTIONABLE').first.id

    Set.new DataModel::Gene
      .joins(:gene_categories)
      .where("gene_categories_genes.gene_claim_category_id = ?", category_id)
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
