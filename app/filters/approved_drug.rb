class ApprovedDrug
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "approved_drugs"
  end

  def axis
    :approved_drugs
  end

  def resolve
    Set.new DataModel::Drug
      .where(approved: true)
      .joins(:interactions)
      .pluck("interactions.id")
  end
end
