class AddDefinitionToInteractionClaimType < ActiveRecord::Migration[5.1]
  def change
	add_column :interaction_claim_types, :definition, :text
  end
end
