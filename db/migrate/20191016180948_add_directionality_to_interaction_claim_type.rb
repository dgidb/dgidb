class AddDirectionalityToInteractionClaimType < ActiveRecord::Migration[5.1]
  def change
	add_column :interaction_claim_types, :directionality, :integer
  end
end
