class CreateJoinTableInteractionSource < ActiveRecord::Migration[5.1]
  def up
    create_table :interactions_sources, id: false do |t|
      t.text :interaction_id, null: false
      t.text :source_id, null: false
    end
    execute 'ALTER TABLE interactions_sources ADD PRIMARY KEY (interaction_id, source_id)'
    execute 'ALTER TABLE interactions_sources ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id)'
    execute 'ALTER TABLE interactions_sources ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id)'
  end

  def down
    drop_table :interactions_sources
  end
end
