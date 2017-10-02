json.matchedTerms @search_results.matched_results do |result|
  if result.type == 'drugs'
    json.searchTerm result.search_term
    json.drugName result.identifier.name
    json.interactions result.interactions do |interaction|
      json.interactionId interaction.interaction_id
      json.interactionType interaction.types_string
      json.geneName interaction.gene_name
      json.geneLongName interaction.gene_long_name
      json.source interaction.source_db_name
    end
  else
    json.searchTerm result.search_term
    json.geneName result.identifier.name
    json.geneLongName result.identifier.long_name
    json.geneCategories result.potentially_druggable_categories
    json.interactions result.interactions do |interaction|
      json.interactionId interaction.interaction_id
      json.interactionType interaction.types_string
      json.drugName interaction.drug_name
      json.source interaction.source_db_name
    end
  end
end

json.unmatchedTerms @search_results.unmatched_results do |result|
  json.searchTerm result.search_term
  json.suggestions result.identifiers.map { |i| i.name }
end

json._warning "This API call is deprecated. Please use /v2/interactions.json"
