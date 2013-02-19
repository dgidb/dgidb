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
    @title ||= "#{drug_claim.title} acting on #{gene_claim.title}"
  end

end
