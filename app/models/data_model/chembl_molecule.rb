module DataModel
  class ChemblMolecule < ActiveRecord::Base
    belongs_to :drug
    has_many :chembl_molecule_synonyms

    def names
      @names ||= ([self.pref_name, self.chembl_id] + self.chembl_molecule_synonyms.pluck(:synonym)).to_set
    end
  end
end

