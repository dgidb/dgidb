class LookupRelatedGenes
  def self.find(gene_names)
    DataModel::Gene.eager_load(gene_gene_interaction_claims: [:interacting_gene])
      .where('lower(genes.name) IN (?)', gene_names.map(&:downcase))
  end
end
