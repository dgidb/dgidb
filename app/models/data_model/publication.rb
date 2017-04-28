module DataModel
	class Publication < ActiveRecord::Base
		include Genome::Extensions::UUIDPrimaryKey
		attr_accessible :pmid, :citation
		attr_accessor :pmid, :citation
		has_and_belongs_to_many :interactions
		has_and_belongs_to_many :interaction_claims
	end
end
