json.matchedTerms @search_results.matched_results do |result|
  json.partial! 'services_v2/interactions/details', result: result
end

json.ambiguousTerms @search_results.ambiguous_results do |result|
  json.partial! 'services_v2/interactions/details', result: result
end

json.unmatchedTerms @search_results.unmatched_results.map(&:search_term)
