class AddIndexesOnNewGeneFields < ActiveRecord::Migration
  def up
    add_index :gene_aliases, :alias
  end

  def down
    remove_index :gene_aliases, :alias
  end
end
