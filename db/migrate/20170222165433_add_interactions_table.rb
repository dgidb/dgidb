class AddInteractionsTable < ActiveRecord::Migration
  def up
    add_column :interaction_claims, :interaction_id, :text
    create_table :interactions, id: false do |t|
      t.text :id, null: false
      t.text :drug_id, null: false
      t.text :gene_id, null: false
      t.text :interaction_type
    end

    execute 'ALTER TABLE interactions ADD PRIMARY KEY(id)'
    execute 'ALTER TABLE interactions ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs (id)'
    execute 'ALTER TABLE interactions ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes (id)'
    execute 'ALTER TABLE interaction_claims ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions (id)'
  end

  def down
    remove_column :interaction_claims, :interaction_id
    drop_table :interactions
  end
end
