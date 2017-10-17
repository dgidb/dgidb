class InteractionDetailPresenter < InteractionPresenter
  def as_json
    super.merge(
      attributes: interaction.interaction_attributes.map{|a| AttributePresenter.new(a).as_json},
      interaction_claims: interaction.interaction_claims.map{|c| InteractionClaimPresenter.new(c).as_json},
    )
  end
end
