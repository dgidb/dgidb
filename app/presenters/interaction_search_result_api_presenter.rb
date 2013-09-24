class InteractionSearchResultApiPresenter
  def initialize(search_result)
    @result = search_result
  end

  def search_term
    @result.search_term
  end

  def gene_name
    gene.name
  end

  def gene_long_name
    gene.long_name
  end

  def potentially_druggable_categories
    gene.gene_claims.flat_map { |gc| gc.gene_claim_categories }
    .map { |c| c.name }
    .uniq
  end

  def has_interactions?
    @interactions.size > 0
  end

  def interactions
    @interactions ||= @result.interaction_claims.map do |i|
      InteractionWrapper.new(i)
    end
  end

  private
  def gene
    @result.interaction_claims
      .first
      .gene_claim
      .genes
      .first
  end

  InteractionWrapper = Struct.new(:interaction_claim) do
    def types_string
      interaction_claim
        .interaction_claim_types
        .join(',')
    end

    def interaction_id
      interaction_claim.id
    end

    def source_db_name
      interaction_claim.source.source_db_name
    end

    def drug_name
      interaction_claim.drug_claim.primary_name ||
        interaction_claim.drug_claim.name
    end
  end
end
