class InteractionSearchResult

  attr_accessor :search_term, :genes, :interaction_claims

  def initialize(search_terms, genes)
    @search_term = search_terms.join(', ')
    @search_terms = search_terms
    @genes = genes.uniq
    @interaction_claims = genes.flat_map { |g| g.gene_claims }
      .flat_map{ |gc| gc.interaction_claims }
      .uniq
  end

  def is_ambiguous?
    genes.length > 1
  end

  def is_definite?
    genes.length == 1
  end

  def has_results?
    genes.length > 0
  end

  def has_interactions?
    interaction_claims.length > 0
  end

  def filter_interactions
    @interaction_claims = @interaction_claims.select{ |interaction| yield interaction }
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
