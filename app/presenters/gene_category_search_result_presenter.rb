class GeneCategorySearchResultPresenter < SimpleDelegator
  include Genome::Extensions
  attr_accessor :gene_category, :search_terms
  def initialize(gene_category, search_result, view_context)
    super(search_result)
    @gene_category = gene_category
    @search_terms = [search_result.search_term]
    @view_context = view_context
  end

  def display_search_term
    @search_terms.uniq.join(', ')
  end

  def sources
    sources_with_category.map { |s| TrustLevelPresenter.source_link_with_trust_flag(@view_context, s) }
      .join(' ')
      .html_safe
  end

  private
  def sources_with_category
    gene_claims.select do |gc|
      gc.gene_claim_categories.map(&:name)
      .include?(gene_category.upcase)
    end.map { |gc| gc.source }
  end
end

