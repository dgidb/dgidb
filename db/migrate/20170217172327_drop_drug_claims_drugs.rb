class DropDrugClaimsDrugs < ActiveRecord::Migration[4.2]
  def up
    execute 'update drug_claims set drug_id = (select drugs.id from drugs, drug_claims_drugs where drugs.id = drug_claims_drugs.drug_id and drug_claims_drugs.drug_claim_id = drug_claims.id) '
    drop_table :drug_claims_drugs
  end
end
