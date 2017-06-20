module DataModel
  class ChemblMolecule < ActiveRecord::Base
    belongs_to :drug
    has_many :chembl_molecule_synonyms
    attr_accessible :availability_type, :black_box_warning, :chebi_par_id, :chembl_id, :chirality, :dosed_ingredient,
                    :first_approval, :first_in_class, :indication_class, :inorganic_flag, :max_phase, :molecule_type,
                    :molregno, :natural_product, :oral, :parenteral, :polymer_flag, :pref_name, :prodrug,
                    :structure_type, :therapeutic_flag, :topical, :usan_stem, :usan_stem_definition, :usan_substem,
                    :usan_year, :withdrawn_country, :withdrawn_flag, :withdrawn_reason, :withdrawn_year
  end
end

