class AddIndexesOnNewGeneFields < ActiveRecord::Migration[4.2]
  def up
    add_index :gene_aliases, :alias
  end

  def down
    remove_index :gene_aliases, :alias
  end
end
