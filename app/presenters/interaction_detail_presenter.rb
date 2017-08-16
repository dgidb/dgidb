class InteractionDetailPresenter < InteractionPresenter
  def data
    super.merge(
      attributes: interaction.interaction_attributes.map{|a| AttributePresenter.new(a).data},
      interaction_claims: interaction.interaction_claims.map{|c| InteractionClaimPresenter.new(c).data},
    )
  end
end
