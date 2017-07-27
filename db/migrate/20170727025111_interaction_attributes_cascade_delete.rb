class InteractionAttributesCascadeDelete < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :interaction_attributes, :interactions
    add_foreign_key :interaction_attributes, :interactions, on_delete: :cascade

    remove_foreign_key :drug_aliases, :drugs
    add_foreign_key :drug_aliases, :drugs, on_delete: :cascade
  end
end
