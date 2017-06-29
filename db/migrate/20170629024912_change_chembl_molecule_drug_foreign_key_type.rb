class ChangeChemblMoleculeDrugForeignKeyType < ActiveRecord::Migration[5.1]
  def change
    change_column :chembl_molecules, :drug_id, :text
  end
end
