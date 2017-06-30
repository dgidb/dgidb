class AddChemblIdToDrugs < ActiveRecord::Migration[4.2]
  def change
    add_column :drugs, :chembl_id, :string
  end
end
