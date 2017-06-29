class AddSynTypeToChemblMoleculeSynonyms < ActiveRecord::Migration[4.2]
  def change
    add_column :chembl_molecule_synonyms, :syn_type, :string, :limit => 50
  end
end
