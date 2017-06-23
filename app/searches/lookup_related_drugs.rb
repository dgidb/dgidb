class LookupRelatedDrugs

  def self.find(drug_name)
    drug_name = drug_name.gsub('(', '\(').gsub(')', '\)').gsub(':', '\:')
    drugs = DataModel::Drug.advanced_search(name: drug_name)
    #Can we get rid of thise case?
    drugs += DataModel::DrugClaim.preload(:drug)
      .advanced_search(name: drug_name).map(&:drug)
    drugs += DataModel::DrugAlias.preload(:drug)
      .advanced_search(alias: drug_name).map(&:drug)

    drugs.uniq { |d| d.id }
      .reject { |d| d.name == drug_name }
      .map { |d| RelatedDrugPresenter.new(d) }
  end
end
