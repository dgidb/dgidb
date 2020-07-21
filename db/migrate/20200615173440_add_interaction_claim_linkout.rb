class AddInteractionClaimLinkout < ActiveRecord::Migration[6.0]
  def change
    create_table :interaction_claim_links, id: false do |t|
      t.text :id, null: false, primary_key: true
      t.text :interaction_claim_id, null: false
      t.string :link_text, null: false
      t.string :link_url, null: false
    end

    add_foreign_key :interaction_claim_links, :interaction_claims
  end
end
