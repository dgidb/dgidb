class FurtherNormalization < ActiveRecord::Migration[3.2]
  def up
    #add column for display name at the gene level - most likely entrez name
    add_column :genes, :display_name, :string

    #add new table and corresponding FK column to hold "source type" information
    add_column :sources, :source_type_id, :string

    create_table :source_types, id: false do |t|
      t.string :id, null: false
      t.string :type, null: false
    end

    execute 'ALTER TABLE source_types ADD PRIMARY KEY (id)'
    execute 'CREATE INDEX ON sources (source_type_id)'
    execute 'ALTER TABLE sources ADD CONSTRAINT fk_source_type FOREIGN KEY (source_type_id) REFERENCES source_types (id) MATCH FULL'
  end

  def down
    remove_column :sources, :source_type_id
    drop_table :source_types
  end
end
