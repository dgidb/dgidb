class AddInteractionsTable < ActiveRecord::Migration
  def up
    add_column :interaction_claims, :interaction_id, :text
    create_table :interactions, id: false do |t|
      t.text :id, null: false
      t.text :drug_id, null: false
      t.text :gene_id, null: false
    end

    execute 'ALTER TABLE interactions ADD PRIMARY KEY(id)'
    execute 'ALTER TABLE interactions ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs (id)'
    execute 'ALTER TABLE interactions ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes (id)'
    execute 'ALTER TABLE interaction_claims ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions (id)'

    create_table :interaction_types_interactions, id: false do |t|
      t.text :interaction_claim_type_id, null: false
      t.text :interaction_id, null: false
    end

    execute 'ALTER TABLE interaction_types_interactions ADD PRIMARY KEY(interaction_claim_type_id, interaction_id)'
    execute 'ALTER TABLE interaction_types_interactions ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions (id)'
    execute 'ALTER TABLE interaction_types_interactions ADD CONSTRAINT fk_interaction_type FOREIGN KEY (interaction_claim_type_id) REFERENCES interaction_claim_types (id)'
  end

  def down
    drop_table :interaction_types_interactions
    remove_column :interaction_claims, :interaction_id
    drop_table :interactions
  end
end
