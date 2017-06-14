class FdaApprovedDrug
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "fda_approved_drugs"
  end

  def axis
    :fda_approved_drugs
  end

  def resolve
    Set.new DataModel::DrugAttribute
      .where(name: ['FDA Approval', 'Year of Approval'])
      .joins(drug: {interactions: :interaction_claims})
      .pluck("interaction_claims.id")
  end
end
