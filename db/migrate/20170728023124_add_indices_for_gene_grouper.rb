class AddIndicesForGeneGrouper < ActiveRecord::Migration[5.1]
  def change
    add_index :genes, 'upper(name)', name: 'genes_index_on_upper_name'
    add_index :genes, 'upper(long_name)', name: 'genes_index_on_upper_long_name'
    add_index :gene_aliases, 'upper(alias)', name: 'gene_aliases_index_on_upper_alias'
  end
end
