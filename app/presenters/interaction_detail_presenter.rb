class InteractionDetailPresenter < InteractionPresenter
  def data
    super.merge(
      attributes: interaction.interaction_attributes.map{|a| AttributePresenter.new(a).data}
    )
  end
end
