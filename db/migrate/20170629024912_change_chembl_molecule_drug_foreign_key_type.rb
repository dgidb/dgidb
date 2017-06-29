class ChangeChemblMoleculeDrugForeignKeyType < ActiveRecord::Migration[4.2]
  def change
    change_column :chembl_molecules, :drug_id, :text
  end
end
