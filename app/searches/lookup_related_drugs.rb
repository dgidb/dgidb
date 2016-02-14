class LookupRelatedDrugs

  def self.find(drug_name)
    drug_name = drug_name.gsub('(', '\(').gsub(')', '\)')
    drugs = DataModel::Drug.advanced_search(name: drug_name)
    drugs += DataModel::DrugClaim.preload(:drugs)
      .advanced_search(name: drug_name).flat_map { |dc| dc.drugs }
    drugs += DataModel::DrugClaimAlias.preload(drug_claim: [:drugs])
      .advanced_search(alias: drug_name)
      .map { |dca| dca.drug_claim }
      .flat_map { |dc| dc.drugs }

    drugs.uniq_by { |d| d.id }
      .reject { |d| d.name == drug_name }
      .map { |d| RelatedDrugPresenter.new(d) }
  end
end
