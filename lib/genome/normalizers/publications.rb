module Genome
	module Normalizers
		class Publications
			def self.populate_interaction_claims
				iclaims = DataModel::InteractionClaimAttribute.all(conditions: {name: "PMID"})
				iclaims |= DataModel::InteractionClaimAttribute.all(conditions: {name: "PubMed ID for Interaction"})
				iclaims.map{|pmid|
					puts(pmid.value) 
					new_pub = DataModel::Publication.where(pmid: pmid.value).first_or_create(pmid: pmid.value, citation: PMID.get_citation_from_pubmed_id(pmid.value))
					pmid.interaction_claim.publications << new_pub unless pmid.interaction_claim.publications.include? new_pub
					#pmid.delete
				}
			end
		end
	end
end
