class AllowMultipleSourceTypes < ActiveRecord::Migration[6.0]
  def up
    create_table :source_types_sources, id: false do |t|
      t.string :source_id, index: true, null: false
      t.string :source_type_id, index: true, null: false
      t.index [:source_type_id, :source_id], unique: true
    end

    execute <<-SQL
      ALTER TABLE source_types_sources ADD CONSTRAINT fk_source_types_source_id
      FOREIGN KEY (source_id) REFERENCES sources (id) MATCH FULL;

      ALTER TABLE source_types_sources ADD CONSTRAINT fk_source_types_source_types_id
      FOREIGN KEY (source_type_id) REFERENCES source_types (id) MATCH FULL;
    SQL

    DataModel::Source.all.each do |source|
      source_type_id = source.source_type_id
      source_id = source.id
      execute <<-SQL
        INSERT INTO source_types_sources (source_type_id, source_id)
        VALUES ('#{source_type_id}', '#{source_id}');
      SQL
    end

    remove_column :sources, :source_type_id
  end

  def down
    drop_table :source_types_sources
    add_column :sources, :source_type_id, :string, index: true
  end
end
