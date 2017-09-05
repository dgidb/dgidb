class ReviseConstraintsOfChemblMolecules < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :chembl_molecules, :drugs
    remove_column :chembl_molecules, :drug_id
    add_column :drugs, :chembl_molecule_id, :integer
    add_foreign_key :drugs, :chembl_molecules
  end
end
