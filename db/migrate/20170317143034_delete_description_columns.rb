class DeleteDescriptionColumns < ActiveRecord::Migration[3.2]
  def up
    remove_column :gene_claims, :description
    remove_column :drug_claims, :description
    remove_column :interaction_claims, :description
  end

  def down
    add_column :interaction_claims, :description, :text
    add_column :drug_claims, :description, :text
    add_column :gene_claims, :description, :text
  end
end
