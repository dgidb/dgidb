class InteractionSearchResult

  attr_accessor :search_term, :identifiers, :interaction_claims, :type

  def initialize(search_terms, identifiers, type = 'genes')
    @search_term = search_terms.join(', ')
    @search_terms = search_terms
    @type = type
    @identifiers = identifiers.uniq
    if type == 'genes'
      results = identifiers.flat_map { |g| g.gene_claims }
        .flat_map{ |gc| gc.interaction_claims }
        .uniq
      @interaction_claims = results.reject do |ic|
        ic.drug_claim.drugs.first.nil?
      end

    else
      results = identifiers.flat_map { |d| d.drug_claims }
        .flat_map{ |dc| dc.interaction_claims }
        .uniq
      @interaction_claims = results.reject do |ic|
        ic.gene_claim.genes.first.nil?
      end

    end
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
