class AddFuzzySearchIndices < ActiveRecord::Migration[5.1]
  def change
    add_index :chembl_molecules, %q{upper(regexp_replace(pref_name, '[^\w]+|_', ''))}, name: 'chembl_molecules_index_on_upper_alphanumeric_pref_name'
    add_index :chembl_molecule_synonyms, %q{upper(regexp_replace(synonym, '[^\w]+|_', ''))}, name: 'chembl_molecule_synonyms_index_on_upper_alphanumeric_synonym'
    add_index :drug_aliases, %q{upper(regexp_replace(alias, '[^\w]+|_', ''))}, name: 'drug_alias_index_on_upper_alphanumeric_alias'
  end
end
