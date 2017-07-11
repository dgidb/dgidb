class DropKnownActionType < ActiveRecord::Migration[5.1]
  def change
    remove_column :interaction_claims, :known_action_type
  end
end
