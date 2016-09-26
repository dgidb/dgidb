class LookupDrugs

  def self.find(search_terms, scope, wrapper_class)
    raise 'You must specify at least one search term!' unless search_terms.any?
    results = match_search_terms_to_objects(search_terms, scope)
    results_to_drugs = match_objects_to_drugs(results, search_terms)
    de_dup_results(results_to_drugs).map do |terms, matched_genes|
      wrapper_class.new(terms, matched_genes, 'drugs')
    end
  end

  private
  def self.match_objects_to_drugs(results, search_terms)
    results_to_drug_groups = search_terms.each_with_object({}) { |term, h| h[term] = [] }
    results.each do |result|
      case result
        when DataModel::Drug
          results_to_drug_groups[result.name] << result
        when DataModel::DrugClaimAlias
          results_to_drug_groups[result.alias] += result.drug_claim.drugs # Come back to this
        when DataModel::DrugClaim
          results_to_drug_groups[result.name] += result.drugs
      end
    end
    results_to_drug_groups
  end

  def self.match_search_terms_to_objects(search_terms, scope)
    search_terms = search_terms.dup
    drug_results = DataModel::Drug.send(scope).where(name: search_terms)
    search_terms = search_terms - drug_results.map(&:name)
    drug_alias_results = DataModel::DrugClaimAlias.send(scope).where(alias: search_terms)
    search_terms = search_terms - drug_alias_results.map(&:alias)
    drug_claim_results = DataModel::DrugClaim.send(scope).where(name: search_terms)

    drug_results.concat(drug_alias_results).concat(drug_claim_results)
  end

  def self.de_dup_results(results)
    non_match_val = 0
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
