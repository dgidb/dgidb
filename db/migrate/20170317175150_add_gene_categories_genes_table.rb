class AddGeneCategoriesGenesTable < ActiveRecord::Migration
  def up
    create_table :gene_categories_genes, id: false do |t|
      t.text :gene_claim_category_id, null: false
      t.text :gene_id, null: false
    end

    execute 'ALTER TABLE gene_categories_genes ADD PRIMARY KEY (gene_claim_category_id, gene_id)'
    execute 'ALTER TABLE gene_categories_genes ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES gene_claim_categories(id)'
    execute 'ALTER TABLE gene_categories_genes ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id)'
  end

  def down
    drop_table :gene_categories_genes
  end
end
