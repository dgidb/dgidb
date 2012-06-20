include Genome::Extensions

class GeneCategorySearchResultPresenter
  attr_accessor :search_term, :gene_category, :group_name
  def initialize(gene_category, search_term, group_name)
    @gene_category = gene_category
    @search_term = search_term
    @group_name = group_name
  end
end

