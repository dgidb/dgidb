class AddDrugAliasesTable < ActiveRecord::Migration
  def up
    remove_column :drug_claim_aliases, :description
    create_table :drug_aliases, id: false do |t|
      t.text :id, null: false
      t.text :drug_id, null: false
      t.text :alias, null: false
      t.text :nomenclature, null: false
      t.text :source_id, null: false
    end

    execute 'ALTER TABLE drug_aliases ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE drug_aliases ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs (id)'
    execute 'ALTER TABLE drug_aliases ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources (id)'
  end

  def down
    drop_table :drug_aliases
  end
end
