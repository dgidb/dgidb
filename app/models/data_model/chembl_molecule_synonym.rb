module DataModel
  class ChemblMoleculeSynonym < ActiveRecord::Base
    belongs_to :chembl_molecule
  end
end