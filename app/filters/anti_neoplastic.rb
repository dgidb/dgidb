class AntiNeoplastic
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "anti_neoplastics"
  end

  def axis
    :anti_neoplastics
  end

  def resolve
    Set.new DataModel::DrugAttribute
      .where(name: ['FDA Approval', 'Year of Approval'])
      .joins(drug: {interactions: :interaction_claims})
      .pluck("interaction_claims.id")
  end
end
