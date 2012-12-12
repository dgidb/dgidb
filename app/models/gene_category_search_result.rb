class GeneCategorySearchResult

  attr_accessor :search_term, :groups

  def initialize(search_term, groups)
    @search_term = search_term
    @groups = groups.uniq
  end

  def is_ambiguous?
    groups.length > 1
  end

  def has_results?
    groups.length > 0
  end

  def gene_group_name
    Maybe(groups.first).name
  end

  def gene_group_display_name
    Maybe(@groups.first).display_name
  end

  def gene_categories
    Maybe(groups.first).genes
      .map {|x| x.gene_categories }
      .flatten.select{|x| x.category_name == "Human Readable Name"}
      .map{|x| x.category_value} || []
  end

  def partition
    if has_results?
      if is_ambiguous?
          :ambiguous
      else
          :definite
      end
    else
      :no_results
    end
  end

end
