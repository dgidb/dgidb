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
        Genome::OnlineUpdater.new().backfill_publication_information
			end
		end
	end
end

