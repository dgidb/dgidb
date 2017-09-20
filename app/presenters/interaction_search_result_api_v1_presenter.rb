class InteractionSearchResultApiV1Presenter
  def initialize(search_result, identifier, interactions)
    @result = search_result
    @identifier = identifier
    @interactions = interactions.flat_map(&:interaction_claims).map{|i| InteractionWrapper.new(i)}
  end

  def identifier
    @identifier
  end

  def search_term
    @result.search_term
  end

  def gene_name
    gene.name
  end

  def drug_name
    drug.name
  end

  def gene_long_name
    gene.long_name
  end

  def type
    @result.type
  end

  def potentially_druggable_categories
    @identifier.gene_claims.flat_map { |gc| gc.gene_claim_categories }
    .map { |c| c.name }
    .uniq
  end

  def has_interactions?
    @interactions.size > 0
  end

  def interactions
    @interactions
  end

  private
  def gene
    @interactions
      .first
      .gene
  end

  def drug
    @interactions
      .first
      .drug
  end

  InteractionWrapper = Struct.new(:interaction_claim) do
    def types_string
      interaction_claim
        .interaction_claim_types
        .map(&:type)
        .join(',')
    end

    def interaction_id
      interaction_claim.id
    end

    def source_db_name
      interaction_claim.source.source_db_name
    end

    def drug
      interaction_claim.drug_claim.drug
    end

    def drug_name
      interaction_claim.drug_claim.primary_name ||
        interaction_claim.drug_claim.name
    end

    def gene
      interaction_claim.gene_claim.gene
    end

    def gene_name
      interaction_claim.gene_claim.gene.name
    end

    def gene_long_name
      interaction_claim.gene_claim.gene.long_name
    end

    def publications
      interaction_claim.publications.map(&:pmid)
    end

  end
end
