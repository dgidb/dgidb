class InteractionSearchResult

  attr_accessor :search_term, :groups, :interactions

  def initialize(search_term, groups)
    @search_term = search_term
    @groups = groups.uniq
    @interactions = groups.map{|group| group.genes}.flatten.inject([]) do |list, gene|
      list += gene.interactions
    end
  end

  def is_ambiguous?
    groups.length > 1
  end

  def has_results?
    groups.length > 0
  end

  def has_interactions?
    interactions.length > 0
  end

  def partition
    if has_results?
      if is_ambiguous? && has_interactions?
          :ambiguous
      elsif is_ambiguous? && !has_interactions?
          :ambiguous_no_interactions
      elsif has_interactions? && !is_ambiguous?
          :definite
      else
          :definite_no_interactions
      end
    else
      :no_results
    end
  end

end
