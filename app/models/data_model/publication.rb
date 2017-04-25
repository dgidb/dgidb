module DataModel
	class Publication < ActiveRecord::Base
		attr_accessible :pmid, :citation

	  has_and_belongs_to_many :interactions
	  has_and_belongs_to_many :interaction_claims
	end
end
