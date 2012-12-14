class InteractionClaimTypeFilter
  def initialize(type)
    @type = type
  end

  def cache_key
    "interaction.type.#{@type}"
  end

  def resolve
    Set.new DataModel::InteractionClaimType.where(type: @type)
      .includes(:interaction_claims)
      .select("interaction_claims.id")
      .first.interaction_claims
      .pluck(:id)
  end
end
