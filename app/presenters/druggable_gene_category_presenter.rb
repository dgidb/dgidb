class DruggableGeneCategoryPresenter
  include Genome::Extensions

  def initialize (search_results)
    @search_results = search_results
  end

  def display_genes
    @display_genes ||= @search_results.map do |result|
      sources = result.gene_claims
                  .map { |claim| claim.source.source_db_name }
      DisplayGene.new(result.long_name, sources)
    end
  end

  private
  class DisplayGene < Struct.new(:gene_name, :sources)
    def source_links(context)
      my_sources = sources
      context.instance_exec do
        my_sources.map{ |name| link_to(name, "/sources/#{name}") }.join(", ").html_safe
      end
    end
  end
end
