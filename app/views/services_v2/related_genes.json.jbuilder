json.genes @genes.each do |gene|
  json.geneSymbol gene.name
  json.relatedGenes gene.gene_gene_interaction_claims.map { |ic| ic.interacting_gene.name }
end
