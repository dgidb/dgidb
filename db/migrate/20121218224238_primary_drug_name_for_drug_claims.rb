class PrimaryDrugNameForDrugClaims < ActiveRecord::Migration[4.2]
  def up
    add_column :drug_claims, :primary_name, :string
  end

  def down
    remove_column :drug_claims, :primary_name
  end
end
