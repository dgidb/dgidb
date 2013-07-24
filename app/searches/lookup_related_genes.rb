class LookupRelatedGenes
  def self.find(gene_names)
    DataModel::Gene.eager_load(gene_gene_interaction_claims: [:interacting_gene])
      .where(name: gene_names)
  end
end
