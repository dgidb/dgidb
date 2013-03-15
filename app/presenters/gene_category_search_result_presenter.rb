class GeneCategorySearchResultPresenter
  include Genome::Extensions
  attr_accessor :search_term, :gene_category, :gene_name, :gene_display_name, :gene, :sources
  def initialize(gene_category, search_term, gene_name, gene_display_name, gene)
    @gene_category = gene_category
    @search_term = search_term
    @gene_name = gene_name
    @gene_display_name = gene_display_name
    @gene = gene
    @sources = sources
  end
end

