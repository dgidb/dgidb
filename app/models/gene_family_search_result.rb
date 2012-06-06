class GeneFamilySearchResult

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

  def gene_families
    Maybe(groups.first).genes
      .map {|x| x.gene_alternate_names }
      .flatten.select{|x| x.nomenclature == "human_readable_name"}
      .map{|x| x.alternate_name} || []
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
