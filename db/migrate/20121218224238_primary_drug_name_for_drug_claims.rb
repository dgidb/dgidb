class PrimaryDrugNameForDrugClaims < ActiveRecord::Migration[3.2]
  def up
    add_column :drug_claims, :primary_name, :string
  end

  def down
    remove_column :drug_claims, :primary_name
  end
end
