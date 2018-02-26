class DropGeneClaimsGenes < ActiveRecord::Migration[3.2]
  def up
    execute 'update gene_claims set gene_id = (select genes.id from genes, gene_claims_genes where genes.id = gene_claims_genes.gene_id and gene_claims_genes.gene_claim_id = gene_claims.id)'
    drop_table :gene_claims_genes
  end

  def down
  end
end
