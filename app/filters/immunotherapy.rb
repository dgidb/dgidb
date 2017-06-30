class Immunotherapy
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "immunotherapies"
  end

  def axis
    :immunotherapies
  end

  def resolve
    Set.new DataModel::Drug
      .where(anti_neoplastic: true)
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
