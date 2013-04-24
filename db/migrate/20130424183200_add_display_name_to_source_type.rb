class AddDisplayNameToSourceType < ActiveRecord::Migration
  def up
    add_column :source_types, :display_name, :string
  end

  def down
    remove_column :source_types, :display_name
  end
end
