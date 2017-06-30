class InteractionSearchResult

  attr_accessor :search_term, :identifiers, :interactions, :type

  def initialize(search_terms, identifiers, type = 'genes')
    @search_term = search_terms.join(', ')
    @search_terms = search_terms
    @type = type
    @identifiers = identifiers.uniq
    @interactions = identifiers.flat_map(&:interactions).uniq
  end

  def is_ambiguous?
    identifiers.length > 1
  end

  def is_definite?
    identifiers.length == 1
  end

  def has_results?
    identifiers.length > 0
  end

  def has_interactions?
    interactions.length > 0
  end

  # yield passes interaction to each block in filter_results from lookup_interactions.rb
  def filter_interactions
    @interactions = @interactions.select{ |interaction| yield interaction }
  end

  def match_type_label
    if is_ambiguous?
      "Ambiguous"
    elsif !has_results?
      "None"
    else
      "Definite"
    end
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
