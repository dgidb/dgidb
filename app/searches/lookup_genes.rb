class LookupGenes

  def self.find(search_terms, scope, wrapper_class, filter = FilterChain.new)
    raise 'You must specify at least one search term!' unless search_terms.any?
    results_to_genes = match_search_terms_to_objects(search_terms, scope, filter)
    de_dup_results(results_to_genes).map do |terms, matched_genes|
      wrapper_class.new(terms, matched_genes.compact)
    end
  end

  private
  def self.match_search_terms_to_objects(search_terms, scope, filter)
    search_terms = search_terms.dup
    results_to_gene_groups = search_terms.each_with_object({}) { |term, h| h[term] = [] }

    unfiltered_gene_results = DataModel::Gene.send(scope).where(["genes.name in (?) or entrez_id in (?)", search_terms, search_terms.map {|x| Integer(x) rescue nil }.compact])
    filtered_gene_results = filter.filter_rel(unfiltered_gene_results)

    ids_to_gene_groups = filtered_gene_results.each_with_object({}) { |gene, h| h[gene.id] = gene}

    unfiltered_gene_results.each do |unfiltered_result|
      result = ids_to_gene_groups[unfiltered_result.id]
      unless result
        result = unfiltered_result.dup
        result.interactions = []
        result.id = unfiltered_result.id
      end
      if results_to_gene_groups.keys().include? result.name
        results_to_gene_groups[result.name] << result
      elsif results_to_gene_groups.keys().include? result.entrez_id.to_s
        results_to_gene_groups[result.entrez_id.to_s] << result
      end
    end
    search_terms = search_terms - unfiltered_gene_results.map(&:name) - unfiltered_gene_results.map(&:entrez_id)

    unfiltered_gene_alias_results = DataModel::GeneAlias.send(scope).where(alias: search_terms)
    filtered_gene_alias_results = filter.filter_rel(unfiltered_gene_alias_results)

    ids_to_gene_groups = filtered_gene_alias_results.each_with_object({}) { |gene, h| h[gene.id] = gene}

    unfiltered_gene_alias_results.each do |unfiltered_result|
      result = ids_to_gene_groups[unfiltered_result.id]
      unless result
        result = unfiltered_result.dup
        result.gene = unfiltered_result.gene.dup
        result.gene.interactions = []
        result.gene.id = unfiltered_result.gene.id
        result.id = unfiltered_result.id
      end
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
