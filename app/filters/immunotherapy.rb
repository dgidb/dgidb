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
    Set.new DataModel::DrugAttribute
      .where(name: ['FDA Approval', 'Year of Approval'])
      .joins(drug: {interactions: :interaction_claims})
      .pluck("interaction_claims.id")
  end
end
