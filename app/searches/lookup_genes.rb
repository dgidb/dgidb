class LookupGenes

  def self.find(search_terms, scope, wrapper_class)
    raise 'You must specify at least one search term!' unless search_terms.any?
    results = match_search_terms_to_objects(search_terms, scope)
    results_to_genes = match_objects_to_genes(results, search_terms)
    de_dup_results(results_to_genes).map do |terms, matched_genes|
      wrapper_class.new(terms, matched_genes)
    end
  end

  private
  def self.match_objects_to_genes(results, search_terms)
    results_to_gene_groups = search_terms.each_with_object({}) { |term, h| h[term] = [] }
    results.each do |result|
      case result
      when DataModel::Gene
        results_to_gene_groups[result.name] << result
      when DataModel::GeneClaimAlias
        results_to_gene_groups[result.alias] += result.gene_claim.genes
      when DataModel::GeneClaim
        results_to_gene_groups[result.name] += result.genes
      end
    end
    results_to_gene_groups
  end

  def self.match_search_terms_to_objects(search_terms, scope)
    search_terms = search_terms.dup
    gene_results = DataModel::Gene.send(scope).where(name: search_terms)
    search_terms = search_terms - gene_results.map(&:name)
    gene_alias_results = DataModel::GeneClaimAlias.send(scope).where(alias: search_terms)
    search_terms = search_terms - gene_alias_results.map(&:alias)
    gene_claim_results = DataModel::GeneClaim.send(scope).where(name: search_terms)

    gene_results.concat(gene_alias_results).concat(gene_claim_results)
  end

  def self.de_dup_results(results)
    uniq_hash = Hash.new { |h, k| h[k] = [] }
    results.each do |search_term, value|
      uniq_hash[value] << search_term
    end
    uniq_hash.invert
  end
end
