class CreateChemblMoleculeSynonyms < ActiveRecord::Migration
  def change
    create_table :chembl_molecule_synonyms do |t|
      t.integer :molregno
      t.string :synonym, :limit => 200
      t.integer :molsyn_id
      t.references :chembl_molecule
    end
  end
end
