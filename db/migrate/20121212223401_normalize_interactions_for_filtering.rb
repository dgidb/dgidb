class NormalizeInteractionsForFiltering < ActiveRecord::Migration[4.2]
  def up
    create_table :interaction_claim_types, id: false do |t|
      t.string :id, null: false
      t.string :type
    end

    create_table :interaction_claim_types_interaction_claims, id: false do |t|
      t.string :interaction_claim_type_id
      t.string :interaction_claim_id
    end

    execute 'ALTER TABLE interaction_claim_types_interaction_claims ADD PRIMARY KEY (interaction_claim_type_id, interaction_claim_id)'
    execute 'ALTER TABLE interaction_claim_types ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE interaction_claim_types_interaction_claims ADD CONSTRAINT fk_interaction_claim_type FOREIGN KEY (interaction_claim_type_id) REFERENCES interaction_claim_types (id) MATCH FULL;'
    execute 'ALTER TABLE interaction_claim_types_interaction_claims ADD CONSTRAINT fk_interaction_claim FOREIGN KEY (interaction_claim_id) REFERENCES interaction_claims (id) MATCH FULL;'

    add_column :interaction_claims, :known_action_type, :string
    add_index  :interaction_claims, :known_action_type
  end

  def down
    drop_table :interaction_claim_types
    drop_table :interaction_claim_types_interaction_claims
    remove_column :interaction_claims, :known_action_type
  end
end
