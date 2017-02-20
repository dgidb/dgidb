class AddGeneIdToGeneClaims < ActiveRecord::Migration
  def up
    add_column :gene_claims, :gene_id, :text
    execute 'ALTER TABLE gene_claims ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes (id) MATCH FULL;'
  end

  def down
    remove_column :gene_claims, :gene_id
  end
end
