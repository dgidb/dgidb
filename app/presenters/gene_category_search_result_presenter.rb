class GeneCategorySearchResultPresenter < SimpleDelegator
  include Genome::Extensions
  attr_accessor :gene_category
  def initialize(gene_category, search_result)
    super(search_result)
    @gene_category = gene_category
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
    gene_claims.select do |gc|
      gc.gene_claim_categories.map(&:name)
      .include?(gene_category.upcase)
    end.map { |gc| gc.source }
  end
end

