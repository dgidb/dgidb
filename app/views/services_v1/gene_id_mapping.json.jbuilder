json.searchTerm @result.search_term
json.matchStatus @result.match_status
json.primaryName @result.primary_name
json.fullName @result.long_name
json.matches @result.matches do |match|
  json.sourceName match[0]
  json.id match[1]
end
