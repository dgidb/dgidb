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
    category_id = DataModel::GeneClaimCategory.where(name: 'DRUG RESISTANCE').first.id

    Set.new DataModel::Gene
      .joins(:gene_categories)
      .where("gene_categories_genes.gene_claim_category_id = ?", category_id)
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
