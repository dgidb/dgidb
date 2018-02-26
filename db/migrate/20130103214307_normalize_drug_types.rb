class NormalizeDrugTypes < ActiveRecord::Migration[3.2]
  def up
    create_table :drug_claim_types, id: false do |t|
      t.string :id, null: false
      t.string :type, null: false
    end

    create_table :drug_claim_types_drug_claims, id: false do |t|
      t.string :drug_claim_id
      t.string :drug_claim_type_id
    end

    execute "ALTER TABLE drug_claim_types ADD PRIMARY KEY (id)"
    execute "ALTER TABLE drug_claim_types_drug_claims ADD PRIMARY KEY (drug_claim_id, drug_claim_type_id)"
    execute "ALTER TABLE drug_claim_types_drug_claims ADD CONSTRAINT fk_drug_claim FOREIGN KEY (drug_claim_id) REFERENCES drug_claims (id) MATCH FULL"
    execute "ALTER TABLE drug_claim_types_drug_claims ADD CONSTRAINT fk_drug_claim_type FOREIGN KEY (drug_claim_type_id) REFERENCES drug_claim_types (id) MATCH FULL"
  end

  def down
    drop_table :drug_claim_types
    drop_table :drug_claim_types_drug_claims
  end
end
