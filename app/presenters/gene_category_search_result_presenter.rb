class GeneCategorySearchResultPresenter
  include Genome::Extensions
  attr_accessor :search_term, :gene_category, :gene_name, :gene_display_name, :gene, :sources
  def initialize(gene_category, search_term, gene_name, gene_display_name, gene, sources)
    @gene_category = gene_category
    @search_term = search_term
    @gene_name = gene_name
    @gene_display_name = gene_display_name
    @gene = gene
    @sources = sources
  end

  def sources(context)
    sources_with_category
      .map do |source|
        context.instance_exec do
          link_to source.source_db_name, source_path(source.source_db_name)
        end
      end
      .join(', ').html_safe
  end

  private
  def sources_with_category
    @gene.gene_claims.select do |gc|
      gc.gene_claim_categories.map(&:name)
      .include?(gene_category.upcase)
    end.map { |gc| gc.source }
  end
end

