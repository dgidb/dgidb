class SearchResult

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

end
