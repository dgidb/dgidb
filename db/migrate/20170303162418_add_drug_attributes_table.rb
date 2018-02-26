class AddDrugAttributesTable < ActiveRecord::Migration[4.2]
  def up
    remove_column :drug_claim_attributes, :description

    create_table :drug_attributes, id: false do |t|
      t.text :id, null: false
      t.text :drug_id, null: false
      t.text :name, null: false
      t.text :value, null: false
    end

    execute 'ALTER TABLE drug_attributes ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE drug_attributes ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id)'

    create_table :drug_attributes_sources, id: false do |t|
      t.text :drug_attribute_id, null: false
      t.text :source_id, null: false
    end

    execute 'ALTER TABLE drug_attributes_sources ADD PRIMARY KEY (drug_attribute_id, source_id)'
    execute 'ALTER TABLE drug_attributes_sources ADD CONSTRAINT fk_drug_attribute FOREIGN KEY (drug_attribute_id) REFERENCES drug_attributes(id)'
    execute 'ALTER TABLE drug_attributes_sources ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id)'
  end

  def down
    drop_table :drug_attributes_sources
    drop_table :drug_attributes
  end
end
