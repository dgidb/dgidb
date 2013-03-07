class SourceTrustLevel
  include Filter

  def initialize(trust_level)
    @source_trust_level = trust_level
  end

  def cache_key
    "source_trust_level.#{@source_trust_level}"
  end

  def axis
    :source_trust_level
  end

  def resolve
    Set.new DataModel::Source.where('source_trust_levels.level' => @source_trust_level)
      .joins(:source_trust_level)
      .joins(:interaction_claims)
      .pluck('interaction_claims.id')
  end
end
