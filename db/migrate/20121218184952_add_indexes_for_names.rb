class AddIndexesForNames < ActiveRecord::Migration
  def up
    add_index :genes, :name
    add_index :gene_claims, :name
    add_index :gene_claim_aliases, :alias

    add_index :gene_claim_attributes, :name
    add_index :gene_claim_attributes, :value

    add_index :drug_claim_attributes, :name
    add_index :drug_claim_attributes, :value
  end

  def down
    remove_index :genes, :name
    remove_index :gene_claims, :name
    remove_index :gene_claim_aliases, :alias

    remove_index :gene_claim_attributes, :name
    remove_index :gene_claim_attributes, :value

    remove_index :drug_claim_attributes, :name
    remove_index :drug_claim_attributes, :value
  end
end
