class LookupGenes

  class << self
    def find(params, scope = :for_search)
      gene_names = params[:gene_names]

      results_to_gene_groups = gene_names.inject({}) do |hash, search_term|
        hash[search_term] = []
        hash
      end

      results = DataModel::GeneGroup.send(scope).where{name.eq_any(gene_names)}
      result_names = results.map(&:name)
      gene_names = gene_names.reject{|name| result_names.include?(name)}
      results += DataModel::GeneAlternateName.send(scope).where{alternate_name.eq_any(gene_names)}
      result_names = results.map{|r| r.respond_to?(:name) ? r.name : r.alternate_name }
      gene_names = gene_names.reject{|name| result_names.include?(name)}
      results += DataModel::Gene.send(scope).where{name.eq_any(gene_names)}

      results.each do |result|
        case result
        when DataModel::GeneGroup
          results_to_gene_groups[result.name] << result
        when DataModel::GeneAlternateName
          results_to_gene_groups[result.alternate_name] += result.gene.gene_groups
        when DataModel::Gene
          results_to_gene_groups[result.name] += result.gene_groups
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
