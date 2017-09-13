class CreateDrugAliasBlacklists < ActiveRecord::Migration[5.1]
  def change
    create_table :drug_alias_blacklists do |t|
      t.text :alias
    end
    add_index :drug_alias_blacklists, :alias, unique: true
  end
end
