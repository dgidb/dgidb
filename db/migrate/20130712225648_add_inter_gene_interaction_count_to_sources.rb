class AddInterGeneInteractionCountToSources < ActiveRecord::Migration
  def up
    add_column :sources, :gene_gene_interaction_claims_count, :integer, default: 0
  end

  def down
    remove_column :sources, :gene_gene_interaction_claims_count
  end
end
