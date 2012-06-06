include Genome::Extensions

class GeneFamilySearchResultPresenter
  attr_accessor :search_term, :gene_family, :group_name
  def initialize(gene_family, search_term, group_name)
    @gene_family = gene_family
    @search_term = search_term
    @group_name = group_name
  end
end

