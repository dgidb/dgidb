class LookupInteractions

  class << self
    def find_groups_and_interactions(gene_names)
      gene_names = Array(gene_names)
      results_to_gene_groups = gene_names.inject({}) do |hash, search_term|
        hash[search_term] = []
        hash
      end
      results = DataModel::GeneGroup.where(name: gene_names).with_genes
      results += DataModel::GeneAlternateName.where(alternate_name: gene_names).with_genes_and_groups
      results.each do |result|
        case result
          when DataModel::GeneGroup
            results_to_gene_groups[result.name] << result
          when DataModel::GeneAlternateName
            results_to_gene_groups[result.alternate_name] += result.gene.gene_groups
        end
      end
      results_to_gene_groups.map{|key, value| SearchResult.new(key, value)}
    end
  end

end
