namespace :dgidb do
	namespace :populate do
		desc 'get citations from PMIDs'
		task publications: :environment do

			all_pmids = DataModel::InteractionAttribute.all(conditions: {name: "PMID"}, select: :value) 
			.concat(DataModel::DrugAttribute.all(conditions: {name: "PMID"}, select: :value))
			.concat(DataModel::GeneAttribute.all(conditions: {name: "PMID"}, select: :value))

			all_pmids.map{|pmid| DataModel::Publication
				.create(pmid: pmid.value, 
					citation: PMID.get_citation_from_pubmed_id(pmid.value), 
					link: PMID.pubmed_url(pmid.value))}
		end
	end
end
