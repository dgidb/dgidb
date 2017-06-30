class DruggableGenome
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "druggable_genome"
  end

  def axis
    :druggable_genome
  end

  def resolve
    category_id = DataModel::GeneClaimCategory.where(name: 'DRUGGABLE GENOME').first.id

    Set.new DataModel::Gene
      .joins(:gene_categories)
      .where("gene_categories_genes.gene_claim_category_id = ?", category_id)
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
