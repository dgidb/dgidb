class LookupRelatedDrugs

  class << self
    def find(drug_name)
      similar_groups = DataModel::DrugGroup.search_by_name(drug_name)
      similar_drugs = []
      drugs = []
      drugs = DataModel::Drug.preload(:drug_groups).search_by_name(drug_name)
      drug_alt_names = DataModel::DrugAlternateName.preload(drug: [:drug_groups]).search_by_alternate_name(drug_name)
      drugs += drug_alt_names.map{|alt| alt.drug}
      drugs.each do |drug|
        if drug.drug_groups
          similar_groups += drug.drug_groups
        else
          similar_drugs << drug
        end
      end
      (similar_groups.uniq_by {|group| group.id } + similar_drugs.uniq_by { |drug| drug.id }).map{|d| RelatedDrugPresenter.new(d)}
    end
  end

end
