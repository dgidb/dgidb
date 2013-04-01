class GeneCategorySearchResultPresenter < SimpleDelegator
  include Genome::Extensions
  attr_accessor :gene_category, :search_terms
  def initialize(gene_category, search_result)
    super(search_result)
    @gene_category = gene_category
    @search_terms = [search_result.search_term]
  end

  def display_search_term
    @search_terms.uniq.join(', ')
  end

  def sources(context)
    sources_with_category.map { |s| TrustLevelPresenter.source_link_with_trust_flag(context, s) }
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

