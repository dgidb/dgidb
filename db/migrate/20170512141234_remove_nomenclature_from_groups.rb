class RemoveNomenclatureFromGroups < ActiveRecord::Migration
  def up
    remove_column :gene_aliases, :nomenclature
    remove_column :drug_aliases, :nomenclature
  end

  def down
    add_column :gene_aliases, :nomenclature, :text
    add_column :drug_aliases, :nomenclature, :text
  end
end
