class AddInterGeneInteractionCountToSources < ActiveRecord::Migration
  def up
    add_column :sources, :inter_gene_interaction_claims_count, :integer
  end

  def down
    remove_column :sources, :inter_gene_interaction_claims_count
  end
end
