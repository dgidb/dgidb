class DrugClaimPresenter < SimpleDelegator

  def drug_claim_name
   primary_name || name
  end

  def title
    if !name.blank? && drug_claim_name != name
      "#{name} (#{primary_name})".html_safe
    else
      drug_claim_name.html_safe
    end
  end

  def publications
    interaction_claim.publications
  end

end
