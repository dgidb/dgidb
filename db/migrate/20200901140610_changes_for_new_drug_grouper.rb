class ChangesForNewDrugGrouper < ActiveRecord::Migration[6.0]
  def up
    rename_column :drugs, :chembl_id, :concept_id
    remove_column :drugs, :chembl_molecule_id

    drop_table :chembl_molecules
    drop_table :chembl_molecule_synonyms

    remove_index :drugs, :name
    add_index :drugs, [:name, :concept_id], :unique => true
  end
end
