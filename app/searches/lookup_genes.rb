class LookupGenes

  def self.find(search_terms, scope, wrapper_class)
    raise 'You must specify at least one search term!' unless search_terms.any?
    results_to_genes = match_search_terms_to_objects(search_terms, scope)
    de_dup_results(results_to_genes).map do |terms, matched_genes|
      wrapper_class.new(terms, matched_genes.compact)
    end
  end

  private
  def self.match_search_terms_to_objects(search_terms, scope)
    search_terms = search_terms.dup
    results_to_gene_groups = search_terms.each_with_object({}) { |term, h| h[term] = [] }

    gene_results = DataModel::Gene.send(scope).where(["name in (?) or entrez_id in (?)", search_terms, search_terms.map {|x| Integer(x) rescue nil }.compact])
    gene_results.each do |result|
      if results_to_gene_groups.keys().include? result.name
        results_to_gene_groups[result.name] << result
      elsif results_to_gene_groups.keys().include? result.entrez_id.to_s
        results_to_gene_groups[result.entrez_id.to_s] << result
      end
    end
    search_terms = search_terms - gene_results.map(&:name) - gene_results.map(&:entrez_id)

    gene_alias_results = DataModel::GeneAlias.send(scope).where(alias: search_terms)
    gene_alias_results.each do |result|
      results_to_gene_groups[result.alias] << result.gene
    end



    results_to_gene_groups
  end

  def self.de_dup_results(results)
    uniq_hash = Hash.new { |h, k| h[k] = [] }
    results.each do |search_term, value|
      uniq_hash[value] << search_term
    end
    uniq_hash.invert
  end
end
