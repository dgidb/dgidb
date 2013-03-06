json.matchedTerms @search_results.matched_results do |result|
  json.searchTerm result.search_term
  json.geneName result.gene_name
  json.geneLongName result.gene_long_name
  json.geneCategories result.potentially_druggable_categories
  json.interactions result.interactions do |interaction|
    json.interactionId interaction.interaction_id
    json.interactionType interaction.types_string
    json.drugName interaction.drug_name
    json.source interaction.source_db_name
  end
end

json.unmatchedTerms @search_results.unmatched_results do |result|
  json.searchTerm result.search_term
  json.suggestions result.genes.map { |g| g.name }
end