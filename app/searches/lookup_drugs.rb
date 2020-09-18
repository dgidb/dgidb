class LookupDrugs

  def self.find(search_terms, scope, wrapper_class, filter = FilterChain.new)
    raise 'You must specify at least one search term!' unless search_terms.any?
    unfiltered_results, filtered_results = match_search_terms_to_objects(search_terms, scope, filter)
    results_to_drugs = match_objects_to_drugs(unfiltered_results, filtered_results, search_terms)
    de_dup_results(results_to_drugs).map do |terms, matched_drugs|
      wrapper_class.new(terms, matched_drugs.compact, 'drugs')
    end
  end

  private
  def self.match_objects_to_drugs(unfiltered_results, filtered_results, search_terms)
    results_to_drug_groups = search_terms.each_with_object({}) { |term, h| h[term] = [] }
    ids_to_results = filtered_results.each_with_object({}) { |result, h| h[result.id] = result}
    unfiltered_results.each do |unfiltered_result|
      result = ids_to_results[unfiltered_result.id]
      unless result
        case unfiltered_result
          when DataModel::Drug
            result = unfiltered_result.dup
            result.interactions = []
            result.id = unfiltered_result.id
          when DataModel::DrugAlias
            result = unfiltered_result.dup
            result.drug = unfiltered_result.drug.dup
            result.drug.interactions = []
            result.drug.id = unfiltered_result.drug.id
            result.id = unfiltered_result.id
        end
      end
      case result
        when DataModel::Drug
          results_to_drug_groups[result.name] << result if results_to_drug_groups.include? result.name
          results_to_drug_groups[result.concept_id] << result if results_to_drug_groups.include? result.concept_id
        when DataModel::DrugAlias
          results_to_drug_groups[result.alias] << result.drug
      end
    end
    results_to_drug_groups
  end

  def self.match_search_terms_to_objects(search_terms, scope, filter)
    search_terms = search_terms.dup

    unfiltered_drug_results = DataModel::Drug.send(scope).where(["drugs.name in (?) or concept_id in (?)", search_terms, search_terms])
    filtered_drug_results = filter.filter_rel(unfiltered_drug_results)

    search_terms = search_terms - unfiltered_drug_results.map(&:name) - unfiltered_drug_results.map(&:concept_id)

    unfiltered_drug_alias_results = DataModel::DrugAlias.send(scope).where(alias: search_terms)
    filtered_drug_alias_results = filter.filter_rel(unfiltered_drug_alias_results)

    unfiltered_results = unfiltered_drug_results.to_a.concat(unfiltered_drug_alias_results.to_a)
    filtered_results = filtered_drug_results.to_a.concat(filtered_drug_alias_results.to_a)

    return unfiltered_results, filtered_results
  end

  def self.de_dup_results(results)
    uniq_hash = Hash.new { |h, k| h[k] = [] }
    results.each do |search_term, value|
      if value != []
        uniq_hash[value] << search_term
      else
        drug = DataModel::Drug.for_show.where('lower(drugs.name) = ?', search_term.downcase)
        uniq_hash[drug] << search_term
      end
    end
    uniq_hash.invert
  end
end
