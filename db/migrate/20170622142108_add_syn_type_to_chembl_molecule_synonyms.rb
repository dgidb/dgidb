class AddSynTypeToChemblMoleculeSynonyms < ActiveRecord::Migration
  def change
    add_column :chembl_molecule_synonyms, :syn_type, :string, :limit => 50
  end
end
