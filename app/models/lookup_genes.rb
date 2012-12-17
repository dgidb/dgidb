class LookupGenes

  class << self
    def find(params, scope = :for_search)
      gene_names = params[:gene_names]

      results_to_gene_groups = gene_names.inject({}) do |hash, search_term|
        hash[search_term] = []
        hash
      end

      results = DataModel::Gene.send(scope).where{name.eq_any(gene_names)}
      result_names = results.map(&:name)
      gene_names = gene_names.reject{|name| result_names.include?(name)}
      results += DataModel::GeneClaimAlias.send(scope).where(alias: gene_names)
      result_names = results.map{|r| r.respond_to?(:name) ? r.name : r.alias }
      gene_names = gene_names.reject{|name| result_names.include?(name)}
      results += DataModel::GeneClaim.send(scope).where{name.eq_any(gene_names)}

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
      if scope == :for_search
        results_to_gene_groups.map{ |key, value| InteractionSearchResult.new(key, value) }
      else
        results_to_gene_groups.map{ |key, value| GeneCategorySearchResult.new(key, value) }
      end
    end
  end

end
