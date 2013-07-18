class AddGeneGeneInteractionTable < ActiveRecord::Migration
  def up
    create_table :gene_gene_interaction_claims, id: false do |t|
      t.string :id, null: false
      t.string :gene_id, null: false
      t.string :interacting_gene_id, null: false
      t.string :source_id, null: false
    end

    create_table :gene_gene_interaction_claim_attributes, id: false do |t|
      t.string :id, null: false
      t.string :gene_gene_interaction_claim_id, null: false
      t.string :name, null: false
      t.string :value, null: false
    end

    add_index :gene_gene_interaction_claims, :gene_id
    add_index :gene_gene_interaction_claims, :interacting_gene_id

    execute 'ALTER TABLE gene_gene_interaction_claims ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE gene_gene_interaction_claims ADD CONSTRAINT fk_gene_interaction_claims_sources FOREIGN KEY (source_id) REFERENCES sources (id) MATCH FULL'
    execute 'ALTER TABLE gene_gene_interaction_claims ADD CONSTRAINT fk_gene_interaction_claims_gene FOREIGN KEY (gene_id) REFERENCES genes (id) MATCH FULL'
    execute 'ALTER TABLE gene_gene_interaction_claims ADD CONSTRAINT fk_gene_interaction_claims_interacting_gene FOREIGN KEY (interacting_gene_id) REFERENCES genes (id) MATCH FULL'
    execute 'CREATE INDEX left_and_interacting_gene_interaction_index ON gene_gene_interaction_claims (gene_id, interacting_gene_id)'

    execute 'ALTER TABLE gene_gene_interaction_claim_attributes ADD PRIMARY KEY (gene_gene_interaction_claim_id)'
    execute 'ALTER TABLE gene_gene_interaction_claim_attributes ADD CONSTRAINT fk_attributes_gene_interaction_claim FOREIGN KEY (gene_gene_interaction_claim_id) REFERENCES gene_gene_interaction_claims (id) MATCH FULL'
  end

  def down
    execute 'DROP TABLE gene_gene_interaction_claims CASCADE'
    execute 'DROP TABLE gene_gene_interaction_claim_attributes CASCADE'
  end
end
