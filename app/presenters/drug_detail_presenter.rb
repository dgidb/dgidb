class DrugDetailPresenter < DrugPresenter
  def data
    super.merge(
      pmids: self.publications.map(&:pmid),
      attributes: drug.drug_attributes.map{|a| AttributePresenter.new(a).data},
      drug_claims: drug.drug_claims.map{|c| DrugClaimPresenter.new(c).data},
    )
  end
end
