module Utils
  module Grouper
    def self.export_ungrouped_drugs_csv
      all_ungrouped_drugs = DataModel::DrugClaim.includes(:drug_claim_aliases, :source).where(drug_id: nil)
      CSV.open('ungrouped_drugs.csv', 'wb') do |csv|
        all_ungrouped_drugs.each {|dc| csv << [dc.source.source_db_name, dc.name, dc.primary_name, dc.drug_claim_aliases.pluck(:alias).join('|')]}
      end
    end

    def self.ungrouped_drug_count(relation = DataModel::DrugClaim)
      relation
          .includes(:drug_claim_aliases, :source)
          .where(drug_id: nil)
          .group(:source)
          .size
          .each_with_object({}) { |(k, v), h| h[k.source_db_name] = v}
    end

    def self.total_drug_count(relation = DataModel::DrugClaim)
      relation
          .includes(:source)
          .group(:source)
          .size
          .each_with_object({}) { |(k, v), h| h[k.source_db_name] = v}
    end

    def self.total_ungrouped_percentage(relation = DataModel::DrugClaim)
      ungrouped = ungrouped_drug_count relation
      total = total_drug_count relation
      ungrouped.values.sum / total.values.sum.to_f
    end

    def self.ungrouped_percentages(relation = DataModel::DrugClaim)
      ungrouped = ungrouped_drug_count relation
      total = total_drug_count relation
      ungrouped.keys.each_with_object({}) { |k, h| h[k] = ungrouped[k] / total[k].to_f}
    end
  end
end
