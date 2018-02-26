class AddDrugIdToDrugClaims < ActiveRecord::Migration[3.2]
  def up
    add_column :drug_claims, :drug_id, :text
    execute 'ALTER TABLE drug_claims ADD CONSTRAINT fk_drug FOREIGN KEY (drug_id) REFERENCES drugs (id) MATCH FULL;'
  end

  def down
    remove_column :drug_claims, :drug_id
  end
end
