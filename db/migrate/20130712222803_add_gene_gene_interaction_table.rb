class AddGeneGeneInteractionTable < ActiveRecord::Migration
  def up
    create_table :inter_gene_interaction_claims, id: false do |t|
      t.string :id, null: false
      t.string :left_gene_id, null: false
      t.string :right_gene_id, null: false
      t.string :source_id, null: false
    end

    create_table :inter_gene_interaction_claim_attributes, id: false do |t|
      t.string :id, null: false
      t.string :inter_gene_interaction_claim_id, null: false
      t.string :name, null: false
      t.string :value, null: false
    end

    add_index :inter_gene_interaction_claims, :left_gene_id
    add_index :inter_gene_interaction_claims, :right_gene_id

    execute 'ALTER TABLE inter_gene_interaction_claims ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE inter_gene_interaction_claims ADD CONSTRAINT fk_gene_interaction_claims_sources FOREIGN KEY (source_id) REFERENCES sources (id) MATCH FULL'
    execute 'ALTER TABLE inter_gene_interaction_claims ADD CONSTRAINT fk_gene_interaction_claims_left_gene FOREIGN KEY (left_gene_id) REFERENCES genes (id) MATCH FULL'
    execute 'ALTER TABLE inter_gene_interaction_claims ADD CONSTRAINT fk_gene_interaction_claims_right_gene FOREIGN KEY (right_gene_id) REFERENCES genes (id) MATCH FULL'
    execute 'CREATE INDEX left_and_right_gene_interaction_index ON inter_gene_interaction_claims (left_gene_id, right_gene_id)'

    execute 'ALTER TABLE inter_gene_interaction_claim_attributes ADD PRIMARY KEY (inter_gene_interaction_claim_id)'
    execute 'ALTER TABLE inter_gene_interaction_claim_attributes ADD CONSTRAINT fk_attributes_gene_interaction_claim FOREIGN KEY (inter_gene_interaction_claim_id) REFERENCES inter_gene_interaction_claims (id) MATCH FULL'
  end

  def down
    drop_table :inter_gene_interaction_claims
    drop_table :inter_gene_interaction_claim_attributes
  end
end
