class InteractionSearchResultApiV2Presenter
  def initialize(search_result)
    @result = search_result
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
    gene.gene_claims.flat_map { |gc| gc.gene_claim_categories }
    .map { |c| c.name }
    .uniq
  end

  def has_interactions?
    @interactions.size > 0
  end

  def interactions
    @interactions ||= @result.interactions.map do |i|
      InteractionWrapper.new(i)
    end
  end

  private
  def gene
    @result.interactions
      .first
      .gene
  end

  def drug
    @result.interactions
      .first
      .drug
  end

  InteractionWrapper = Struct.new(:interaction) do
    def types_string
      interaction
        .interaction_types
        .map(&:type)
        .join(',')
    end

    def interaction_id
      interaction.id
    end

    def source_db_names
      interaction.sources.map(&:source_db_name)
    end

    def drug_name
      interaction.drug.name
    end

    def gene_name
      interaction.gene.name
    end

    def gene_long_name
      interaction.gene.long_name
    end

    def publications
      interaction.publications.map(&:pmid)
    end

  end
end
