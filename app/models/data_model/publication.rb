module DataModel
	class Publication < ActiveRecord::Base
	  attr_accessible :citation, :pmid
	  has_and_belongs_to_many :genes
	  has_and_belongs_to_many :gene_claims
	  has_and_belongs_to_many :drugs
	  has_and_belongs_to_many :drug_claims
	  has_and_belongs_to_many :interactions
	  has_and_belongs_to_many :interaction_claims

	  self.primary_key = "pmid"
	end
end
