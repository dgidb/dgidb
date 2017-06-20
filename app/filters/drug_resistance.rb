class DrugResistance
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "drug_resistance"
  end

  def axis
    :drug_resistance
  end

  def resolve
    Set.new DataModel::Gene
      .joins(:gene_categories)
      .where("gene_categories_genes.gene_claim_category_id = ?", '655bedfa9d71482796a5a34b87dfb297')
      .joins(interactions: :interaction_claims)
      .pluck("interaction_claims.id")
  end
end
