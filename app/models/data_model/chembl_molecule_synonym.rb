module DataModel
  class ChemblMoleculeSynonym < ActiveRecord::Base
    belongs_to :chembl_molecule
    attr_accessible :molregno, :molsyn_id, :synonym, :syn_type
  end
end