class InteractionClaimPresenter < SimpleDelegator
  def initialize(interaction_claim)
    @interaction_claim = interaction_claim
    super
  end

  def gene_claim
    @wrapped_gene_claim ||= GeneClaimPresenter.new(@interaction_claim.gene_claim)
  end

  def drug_claim
    @wrapped_drug_claim ||= DrugClaimPresenter.new(@interaction_claim.drug_claim)
  end

  def title
    @title ||= "#{drug_claim.title} interacting with #{gene_claim.title}"
  end

  def data
    {
      source: @interaction_claim.source.source_db_name,
      drug: drug_claim.drug_claim_name,
      gene: gene_claim.name,
      interaction_types: @interaction_claim.interaction_claim_types.map{|t| t.type},
      attributes: @interaction_claim.interaction_claim_attributes.map{|a| ClaimAttributePresenter.new(a).data},
      publications: @interaction_claim.publications.map(&:pmid),
    }
  end
end
