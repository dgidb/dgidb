json.matchedTerms @search_results.matched_results do |result|
  if result.type == 'drugs'
    json.searchTerm result.search_term
    json.drugName result.drug_name
    json.interactions result.interactions do |interaction|
      json.interactionId interaction.interaction_id
      json.interactionTypes interaction.types_string
      json.geneName interaction.gene_name
      json.geneLongName interaction.gene_long_name
      json.sources interaction.source_db_names
      json.pmids interaction.publications.map{|p| p.pmid}
    end
  else
    json.searchTerm result.search_term
    json.geneName result.gene_name
    json.geneLongName result.gene_long_name
    json.geneCategories result.potentially_druggable_categories
    json.interactions result.interactions do |interaction|
      json.interactionId interaction.interaction_id
      json.interactionTypes interaction.types_string
      json.drugName interaction.drug_name
      json.sources interaction.source_db_names
      json.pmids interaction.publications
    end
  end
end

json.unmatchedTerms @search_results.unmatched_results do |result|
  json.searchTerm result.search_term
  json.suggestions result.identifiers.map { |i| i.name }
end
