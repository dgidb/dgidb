class GeneCategorySearchResultPresenter
  include Genome::Extensions
  attr_accessor :search_term, :gene_category, :group_name, :group_display_name
  def initialize(gene_category, search_term, group_name, group_display_name)
    @gene_category = gene_category
    @search_term = search_term
    @group_name = group_name
    @group_display_name = group_display_name
  end
end

