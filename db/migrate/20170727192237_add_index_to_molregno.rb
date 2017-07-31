class AddIndexToMolregno < ActiveRecord::Migration[5.1]
  def change
    add_index :chembl_molecules, :molregno
  end
end
