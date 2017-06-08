class CreateChemblMolecules < ActiveRecord::Migration
  def change
    create_table :chembl_molecules do |t|
      t.integer :molregno
      t.string :pref_name, :limit => 255
      t.string :chembl_id, :limit => 20
      t.integer :max_phase
      t.boolean :therapeutic_flag
      t.boolean :dosed_ingredient
      t.string :structure_type, :limit => 10
      t.integer :chebi_par_id
      t.string :molecule_type, :limit => 30
      t.integer :first_approval
      t.boolean :oral
      t.boolean :parenteral
      t.boolean :topical
      t.boolean :black_box_warning
      t.integer :natural_product
      t.integer :first_in_class
      t.integer :chirality
      t.integer :prodrug
      t.integer :inorganic_flag
      t.integer :usan_year
      t.integer :availability_type
      t.string :usan_stem, :limit => 50
      t.boolean :polymer_flag
      t.string :usan_substem, :limit => 50
      t.text :usan_stem_definition, :limit => 1000
      t.text :indication_class, :limit => 1000
      t.boolean :withdrawn_flag
      t.integer :withdrawn_year
      t.text :withdrawn_country, :limit => 2000
      t.text :withdrawn_reason, :limit => 2000
      t.references :drug

      t.timestamps
    end
    add_index :chembl_molecules, :drug_id
  end
end
