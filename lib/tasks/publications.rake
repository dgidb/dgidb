namespace :dgidb do
	namespace :populate do
		desc 'get citations from PMIDs'
		task publications: :environment do
			DataModel::InteractionAttribute.all(conditions: {name: "PMID"}, select: :name)
			
			DataModel::Publication.create(pmid: )