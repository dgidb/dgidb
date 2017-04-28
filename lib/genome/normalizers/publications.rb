module Genome
	module Normalizers
		class Publications
			def self.populate_interaction_claims
				ActiveRecord::Base.transaction do
					iclaims = DataModel::InteractionClaimAttribute.all(conditions: {name: "PMID"})
					iclaims |= DataModel::InteractionClaimAttribute.all(conditions: {name: "PubMed ID for Interaction"})
					iclaims.map{|pmid|
						new_pub = DataModel::Publication.where(pmid: pmid.value).first_or_create(pmid: pmid.value)
						pmid.interaction_claim.publications << new_pub unless pmid.interaction_claim.publications.include? new_pub
						pmid.delete
					}
				end
			end
		end
	end
end

