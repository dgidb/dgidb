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
    Set.new DataModel::Gene
      .joins(:gene_categories)
      .where("gene_categories_genes.gene_claim_category_name = ?", 'CLINICALLY ACTIONABLE')
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
