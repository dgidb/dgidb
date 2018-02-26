class RenameDisplayNameColumn < ActiveRecord::Migration[3.2]
  def up
    rename_column :genes, :display_name, :long_name
  end

  def down
    rename_column :genes, :long_name, :display_name
  end
end
