class LookupGenes

  def self.find(search_terms, scope, wrapper_class)
    results_to_gene_groups = search_terms.each_with_object({}) do |term, hash|
      hash[term] = []
    end

    gene_names = search_terms

    gene_results = DataModel::Gene.send(scope).where(name: gene_names)
    gene_names = gene_names - gene_results.map(&:name)
    gene_alias_results = DataModel::GeneClaimAlias.send(scope).where(alias: gene_names)
    gene_names = gene_names - gene_alias_results.map(&:alias)
    gene_claim_results = DataModel::GeneClaim.send(scope).where(name: gene_names)

    results = gene_results + gene_alias_results + gene_claim_results

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

    results_to_gene_groups.map do |search_term, matched_genes|
      wrapper_class.new(search_term, matched_genes)
    end
  end
end
