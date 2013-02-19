class DrugClaimPresenter < SimpleDelegator

  def drug_claim_name
   primary_name || name
  end

  def title
    if !name.blank? && drug_claim_name != name
      "#{name} (#{primary_name})"
    else
      drug_claim_name
    end
  end

end
