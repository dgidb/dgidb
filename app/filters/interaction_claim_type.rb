class InteractionClaimType
  include Filter
  def initialize(type)
    @type = type.downcase
  end

  def cache_key
    "interaction.type.#{@type}"
  end

  def axis
    :interactions
  end

  def resolve
    Set.new DataModel::InteractionClaimType
      .where('lower(type) = ?', @type)
      .joins(interaction_claims: :interaction)
      .pluck("interactions.id")
  end
end
