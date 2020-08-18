class AddColumnReferenceToInteractionClaimType < ActiveRecord::Migration[6.0]
  def change
    add_column :interaction_claim_types, :reference, :text
  end
end
