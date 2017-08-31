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
    interaction_claims.map{|ic| ic.publications}.flatten.uniq
  end

  def data
    {
      source: source.source_db_name,
      name: name,
      primary_name: primary_name,
      aliases: drug_claim_aliases.map(&:alias),
      attributes: drug_claim_attributes.map{|a| ClaimAttributePresenter.new(a).data},
      publications: publications.map(&:pmid),
    }
  end
end
