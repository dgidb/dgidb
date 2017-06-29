class RemoveTimestampsFromChemblMolecules < ActiveRecord::Migration[4.2]
  def up
    remove_column :chembl_molecules, :created_at
    remove_column :chembl_molecules, :updated_at
  end

  def down
    add_column :chembl_molecules, :updated_at, :string
    add_column :chembl_molecules, :created_at, :string
  end
end
