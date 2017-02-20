class LookupRelatedDrugs

  def self.find(drug_name)
    drug_name = drug_name.gsub('(', '\(').gsub(')', '\)').gsub(':', '\:')
    drugs = DataModel::Drug.advanced_search(name: drug_name)
    drugs += DataModel::DrugClaim.preload(:drug)
      .advanced_search(name: drug_name).map(&:drug)
    drugs += DataModel::DrugClaimAlias.preload(drug_claim: :drug)
      .advanced_search(alias: drug_name)
      .map { |dca| dca.drug_claim }
      .map(&:drug)

    drugs.uniq_by { |d| d.id }
      .reject { |d| d.name == drug_name }
      .map { |d| RelatedDrugPresenter.new(d) }
  end
end
