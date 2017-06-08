class AddGeneAttributesTable < ActiveRecord::Migration
  def up
      remove_column :gene_claim_attributes, :description

      create_table :gene_attributes, id: false do |t|
        t.text :id, null: false
        t.text :gene_id, null: false
        t.text :name, null:false
        t.text :value, null: false
      end

      execute 'ALTER TABLE gene_attributes ADD PRIMARY KEY (id)'
      execute 'ALTER TABLE gene_attributes ADD CONSTRAINT fk_gene FOREIGN KEY (gene_id) REFERENCES genes(id)'

      create_table :gene_attributes_sources, id: false do |t|
        t.text :gene_attribute_id, null:false
        t.text :source_id, null: false
      end

      execute 'ALTER TABLE gene_attributes_sources ADD PRIMARY KEY (gene_attribute_id, source_id)'
      execute 'ALTER TABLE gene_attributes_sources ADD CONSTRAINT fk_gene_attribute FOREIGN KEY (gene_attribute_id) REFERENCES gene_attributes(id)'
      execute 'ALTER TABLE gene_attributes_sources ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id)'
  end

  def down
    drop_table :gene_attributes_sources
    drop_table :gene_attributes
  end
end
