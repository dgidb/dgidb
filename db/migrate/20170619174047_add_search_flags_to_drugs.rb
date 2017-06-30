class AddSearchFlagsToDrugs < ActiveRecord::Migration[4.2]
  def up
    add_column :drugs, :fda_approved, :boolean
    add_column :drugs, :immunotherapy, :boolean
    add_column :drugs, :anti_neoplastic, :boolean
  end

  def down
    remove_column :drugs, :fda_approved
    remove_column :drugs, :immunotherapy
    remove_column :drugs, :anti_neoplastic
  end
end
