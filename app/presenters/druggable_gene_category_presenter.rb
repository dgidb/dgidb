class DruggableGeneCategoryPresenter
  include Genome::Extensions

  def initialize (search_results)
    @search_results = search_results
  end

  def display_genes
    @display_genes ||= @search_results.map do |result|
      sources = result.gene_claims
                  .map { |claim| claim.source }
                  .select { |source| source.source_type_id == DataModel::SourceType.POTENTIALLY_DRUGGABLE }
                  .uniq
                  .sort_by { |s| CategoryResultSortOrder.sort_value(s.source_db_name) }
      DisplayGene.new(result.long_name, sources, result.name)
    end.sort_by { |display_gene| CategoryResultSortOrder.sort_value(display_gene.sources.first.source_db_name) }
  end

  private
  class DisplayGene < Struct.new(:gene_name, :sources, :short_name)
    def source_links(context)
      sources.map { |s| TrustLevelPresenter.source_link_with_trust_flag(context, s) }
        .join(' ')
        .html_safe
    end
  end
end
