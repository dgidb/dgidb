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
      .where("gene_categories_genes.gene_claim_category_name = ?", 'DRUG RESISTANCE')
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
