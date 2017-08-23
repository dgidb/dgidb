class AddIndicesForDrugGrouper < ActiveRecord::Migration[5.1]
  def change
    add_index :chembl_molecules, :chembl_id
    add_index :chembl_molecules, 'upper(pref_name)', name: "chembl_molecules_index_on_upper_pref_name"
    add_index :chembl_molecule_synonyms, 'upper(synonym)', name: "chembl_molecule_synonyms_index_on_upper_synonym"
    add_index :chembl_molecule_synonyms, :chembl_molecule_id
    add_index :drug_aliases, :drug_id
    add_index :drug_aliases, 'upper(alias)', name: "drug_aliases_index_on_upper_alias"
    add_index :drugs, 'upper(name)', name: 'drugs_index_on_upper_name'
  end
end
