class AddInteractionAttributesTable < ActiveRecord::Migration[3.2]
  def up
    create_table :interaction_attributes, id: false do |t|
      t.text :id, null: false
      t.text :interaction_id, null: false
      t.text :name, null: false
      t.text :value, null: false
    end

    execute 'ALTER TABLE interaction_attributes ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE interaction_attributes ADD CONSTRAINT fk_interaction FOREIGN KEY (interaction_id) REFERENCES interactions(id)'

    create_table :interaction_attributes_sources, id: false do |t|
      t.text :interaction_attribute_id, null: false
      t.text :source_id, null: false
    end

    execute 'ALTER TABLE interaction_attributes_sources ADD PRIMARY KEY (interaction_attribute_id, source_id)'
    execute 'ALTER TABLE interaction_attributes_sources ADD CONSTRAINT fk_interaction_attribute FOREIGN KEY (interaction_attribute_id) REFERENCES interaction_attributes(id)'
    execute 'ALTER TABLE interaction_attributes_sources ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id)'
  end

  def down
    drop_table :interaction_attributes_sources
    drop_table :interaction_attributes
  end
end
