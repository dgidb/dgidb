Fabricator(:publication, class_name: 'DataModel::Publication') do
  pmid { sequence(:pmid) }
  citation "MyText"
end
