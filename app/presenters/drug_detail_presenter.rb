class DrugDetailPresenter < DrugPresenter
  def as_json
    super.merge(
      pmids: self.publications.map(&:pmid),
      attributes: drug.drug_attributes.map{|a| AttributePresenter.new(a).as_json},
      drug_claims: drug.drug_claims.map{|c| DrugClaimPresenter.new(c).as_json},
    )
  end
end
