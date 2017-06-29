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
    Set.new DataModel::Gene
      .joins(:gene_categories)
      .where("gene_categories_genes.gene_claim_category_id = ?", 'd3ec2631e0b2434b9dcc008e793d3fa5')
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
