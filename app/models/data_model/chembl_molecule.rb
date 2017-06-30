module DataModel
  class ChemblMolecule < ActiveRecord::Base
    belongs_to :drug
    has_many :chembl_molecule_synonyms

    def names
      @names ||= ([self.pref_name, self.chembl_id] + self.chembl_molecule_synonyms.pluck(:synonym)).to_set
    end

    def duplicate_pref_name?
      self.class.duplicate_pref_names.member? self.pref_name
    end

    def self.duplicate_pref_names(update = false)
      if update
        @@duplicate_pref_names = self.select('pref_name, count(*)')
                                     .group(:pref_name)
                                     .having('count(*) > 1')
                                     .pluck(:pref_name)
                                     .compact
                                     .to_set
      else
        @@duplicate_pref_names ||= self.select('pref_name, count(*)')
                                       .group(:pref_name)
                                       .having('count(*) > 1')
                                       .pluck(:pref_name)
                                       .compact
                                       .to_set
      end
    end

    def create_and_uniquify_drug
      drug = self.create_drug(name: (self.pref_name || self.chembl_id), chembl_id: self.chembl_id)
      drug.name = "#{self.pref_name} (#{self.chembl_id})"
      if DataModel::DrugAlias.where("drug_id = ? and upper(alias) = ?", drug.id, self.pref_name.upcase).none?
        DataModel::DrugAlias.create(drug: drug, alias: self.pref_name)
      end
      drug.save!
      drug
    end
  end
end

