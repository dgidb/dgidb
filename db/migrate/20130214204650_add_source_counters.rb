class AddSourceCounters < ActiveRecord::Migration[3.2]
  def up
    add_column :sources, :gene_claims_count, :integer, default: 0
    add_column :sources, :drug_claims_count, :integer, default: 0
    add_column :sources, :interaction_claims_count, :integer, default: 0
    add_column :sources, :interaction_claims_in_groups_count, :integer, default: 0
    add_column :sources, :gene_claims_in_groups_count, :integer, default: 0
    add_column :sources, :drug_claims_in_groups_count, :integer, default: 0
  end

  def down
    remove_column :sources, :gene_claims_count
    remove_column :sources, :drug_claims_count
    remove_column :sources, :interaction_claims_count
    remove_column :sources, :interaction_claims_in_groups_count
    remove_column :sources, :gene_claims_in_groups_count
    remove_column :sources, :drug_claims_in_groups_count
  end
end
