class AddGeneAliasesTable < ActiveRecord::Migration[3.2]
  def up
    remove_column :gene_claim_aliases, :description

    create_table :gene_aliases, id: false do |t|
      t.text :id, null: false
      t.text :gene_id, null: false
      t.text :alias, null: false
      t.text :nomenclature, null: false
    end

    execute 'ALTER TABLE gene_aliases ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE gene_aliases ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id)'

    create_table :gene_aliases_sources, id: false do |t|
      t.text :gene_alias_id, null: false
      t.text :source_id, null: false
    end

    execute 'ALTER TABLE gene_aliases_sources ADD PRIMARY KEY (gene_alias_id, source_id)'
    execute 'ALTER TABLE gene_aliases_sources ADD CONSTRAINT fk_gene_alias FOREIGN KEY (gene_alias_id) REFERENCES gene_aliases(id)'
    execute 'ALTER TABLE gene_aliases_sources ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id)'
  end

  def down
    drop_table :gene_aliases_sources
    drop_table :gene_aliases
  end
end
