class AddConstraintsToChemblMolecules < ActiveRecord::Migration[5.1]
  def change
    remove_index :chembl_molecules, :molregno
    add_index :chembl_molecules, :molregno, unique: true
    remove_index :chembl_molecules, :chembl_id
    add_index :chembl_molecules, :chembl_id, unique: true

    add_foreign_key :chembl_molecules, :drugs
  end
end
