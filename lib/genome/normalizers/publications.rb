module Genome
	module Normalizers
		class Publications
			def self.populate_interaction_claims
				# create publication objects without citations from interaction claim attributes
				# might be unnecessary if we're creating publications straight from import
				ActiveRecord::Base.transaction do
					iclaims = DataModel::InteractionClaimAttribute.where(name: "PMID").all
					iclaims |= DataModel::InteractionClaimAttribute.where(name: "PubMed ID for Interaction").all
					iclaims.map{|pmid|
						new_pub = DataModel::Publication.where(pmid: pmid.value).first_or_create(pmid: pmid.value)
						pmid.interaction_claim.publications << new_pub unless pmid.interaction_claim.publications.include? new_pub
						pmid.delete
					}
				end
				recurrences = 0
				# scrape pubmed
				while (pubs_without_citations = DataModel::Publication.where(citation: nil)).length > 0 do
					if recurrences > 0
						sleep 300
					end
					pubs_without_citations.each do |pub|
						begin
							retries ||= 0
							pub.citation = PMID.get_citation_from_pubmed_id(pub.pmid)
							pub.save
						rescue
							sleep 1
							retry if (retries += 1) < 3
						end
					end
					recurrences += 1
				end
			end
		end
	end
end

