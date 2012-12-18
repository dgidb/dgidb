class LookupRelatedDrugs

  def self.find(drug_name)
    drugs = DataModel::Drug.search_by_name(drug_name)
    drugs += DataModel::DrugClaim.preload(:drugs)
      .search_by_name(drug_name).flat_map { |dc| dc.drugs }
    drugs += DataModel::DrugClaimAlias.preload(drug_claim: [:drugs])
      .search_by_alias(drug_name)
      .map { |dca| dca.drug_claim }
      .flat_map { |dc| dc.drugs }

    drugs.uniq_by { |d| d.id }
      .reject { |d| d.name == drug_name }
      .map { |d| RelatedDrugPresenter.new(d) }
  end
end
