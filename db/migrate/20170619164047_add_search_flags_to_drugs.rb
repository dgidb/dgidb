class AddSearchFlagsToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :fda_approved, :boolean
    add_column :drugs, :immunotherapy, :boolean
    add_column :drugs, :anti_neoplastic, :boolean
  end
end
