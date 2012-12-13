class NormalizeGeneCategories < ActiveRecord::Migration
  def up
    create_table :gene_claim_categories, id: false do |t|
      t.string :id, null: false
      t.string :name, null: false
    end

    create_table :gene_claim_categories_gene_claims, id: false do |t|
      t.string :gene_claim_id
      t.string :gene_claim_category_id
    end

    execute "ALTER TABLE gene_claim_categories ADD PRIMARY KEY (id)"
    execute "ALTER TABLE gene_claim_categories_gene_claims ADD PRIMARY KEY (gene_claim_id, gene_claim_category_id)"
    execute "ALTER TABLE gene_claim_categories_gene_claims ADD CONSTRAINT fk_gene_claim FOREIGN KEY (gene_claim_id) REFERENCES gene_claims (id) MATCH FULL"
    execute "ALTER TABLE gene_claim_categories_gene_claims ADD CONSTRAINT fk_gene_claim_category FOREIGN KEY (gene_claim_category_id) REFERENCES gene_claim_categories (id) MATCH FULL"
  end

  def down
    drop_table :gene_claim_categories_gene_claims
    drop_table :gene_claim_categories
  end
end
