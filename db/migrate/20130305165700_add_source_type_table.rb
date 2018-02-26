class AddSourceTypeTable < ActiveRecord::Migration[3.2]
  def up
    add_column :sources, :source_trust_level_id, :string
    create_table :source_trust_levels, id: false do |t|
      t.string :id, null: false
      t.string :level, null: false
    end

    execute 'ALTER TABLE source_trust_levels ADD PRIMARY KEY (id)'
    execute 'CREATE INDEX ON sources (source_trust_level_id)'
    execute 'ALTER TABLE sources ADD CONSTRAINT fk_source_trust_level FOREIGN KEY (source_trust_level_id) REFERENCES source_trust_levels (id)'
  end

  def down
    remove_column :sources, :source_trust_level_id
    drop_table :source_trust_levels
  end
end
