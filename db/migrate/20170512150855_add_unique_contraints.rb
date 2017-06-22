class AddUniqueContraints < ActiveRecord::Migration[4.2]
  def up
    execute 'CREATE UNIQUE INDEX unique_drug_id_alias on drug_aliases (drug_id, UPPER(alias))'
    add_index :drug_attributes, [:drug_id, :name, :value], :unique => true
    add_index :drug_claim_aliases, [:drug_claim_id, :alias, :nomenclature], :unique => true, :name => 'unique_drug_claim_aliases'
    add_index :drug_claim_attributes, [:drug_claim_id, :name, :value], :unique => true
    add_index :drug_claims, [:name, :nomenclature, :source_id], :unique => true
    add_index :drugs, [:name], :unique => true
    execute 'CREATE UNIQUE INDEX unique_gene_id_alias on gene_aliases (gene_id, UPPER(alias))'
    add_index :gene_attributes, [:gene_id, :name, :value], :unique => true
    add_index :gene_claim_aliases, [:gene_claim_id, :alias, :nomenclature], :unique => true, :name => 'unique_gene_claim_aliases'
    add_index :gene_claim_attributes, [:gene_claim_id, :name, :value], :unique => true
    add_index :gene_claims, [:name, :nomenclature, :source_id], :unique => true
    #There already exists a non-unique contraint on the name column on genes -
    #remove and re-add to make unique
    remove_index :genes, :column => [:name]
    add_index :genes, [:name], :unique => true
    add_index :interaction_attributes, [:interaction_id, :name, :value], :unique => true, :name => 'unique_interaction_attributes'
    add_index :interaction_claim_attributes, [:interaction_claim_id, :name, :value], :unique => true, :name => 'unique_interaction_claim_attributes'
    add_index :interaction_claims, [:drug_claim_id, :gene_claim_id, :source_id], :unique => true, :name => 'unique_interaction_claims'
    add_index :interactions, [:drug_id, :gene_id], :unique => true
  end

  def down
    remove_index :drug_aliases, name: 'unique_drug_id_alias'
    remove_index :drug_attributes, :column => [:drug_id, :name, :value]
    remove_index :drug_claim_aliases, :name => 'unique_drug_claim_aliases'
    remove_index :drug_claim_attributes, :column => [:drug_claim_id, :name, :value]
    remove_index :drug_claims, :column => [:name, :nomenclature, :source_id]
    remove_index :drugs, :column => [:name]
    remove_index :gene_aliases, name: 'unique_gene_id_alias'
    remove_index :gene_attributes, :column => [:gene_id, :name, :value]
    remove_index :gene_claim_aliases, :name => 'unique_gene_claim_aliases'
    remove_index :gene_claim_attributes, :column => [:gene_claim_id, :name, :value]
    remove_index :gene_claims, :column => [:name, :nomenclature, :source_id]
    remove_index :genes, :column => [:name]
    add_index :genes, [:name]
    remove_index :interaction_attributes, :name => 'unique_interaction_attributes'
    remove_index :interaction_claim_attributes, :name => 'unique_interaction_claim_attributes'
    remove_index :interaction_claims, :name => 'unique_interaction_claims'
    remove_index :interactions, :column => [:drug_id, :gene_id]
  end
end
