class AddDrugAttributesTable < ActiveRecord::Migration
  def up
    remove_column :drug_claim_attributes, :description
    create_table :drug_attributes, id: false do |t|
      t.text :id, null: false
      t.text :drug_id, null: false
      t.text :name, null: false
      t.text :value, null: false
      t.text :source_id, null: false
    end

    execute 'ALTER TABLE drug_attributes ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE drug_attributes ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs(id)'
    execute 'ALTER TABLE drug_attributes ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id)'
  end

  def down
    drop_table :drug_attributes
  end
end
