class AddEntrezIdToGene < ActiveRecord::Migration
  def change
    add_column :genes, :entrez_id, :integer
    add_index :genes, :entrez_id
  end
end
