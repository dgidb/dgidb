class AddChemblIdToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :chembl_id, :string
  end
end
