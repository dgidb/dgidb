module Utils
  module Grouper
    def self.export_unmatched_drugs_csv
      all_unmatched_drugs = DataModel::DrugClaim.includes(:drug_claim_aliases, :source).where(drug_id: nil)
      CSV.open('unmatched_drugs.csv', 'wb') do |csv|
        all_unmatched_drugs.each {|dc| csv << [dc.source.source_db_name, dc.name, dc.primary_name, dc.drug_claim_aliases.pluck(:alias).join('|')]}
      end
    end

    def self.test_group_drug_claim(drug_claim)
      if drug_claim.drug
        return 'Already grouped'
      end
      results = drug_grouper_dry_run DataModel::DrugClaim.where(id: drug_claim.id)
      if results[:post_count].values.sum == 1
        return 'Successfully grouped'
      end
      grouper = results[:grouper]
      if grouper.direct_multimatch
        return DataModel::Drug.where('upper(name) in (?) or chembl_id IN (?)', drug_claim.names, drug_claim.names)
      elsif grouper.molecule_multimatch
        return 'Molecule multimatch'
      elsif grouper.indirect_multimatch
        return 'Indirect multimatch'
      elsif grouper.fuzzy_multimatch
        return 'Fuzzy multimatch'
      else
        return 'No match'
      end
    end

    def self.drug_grouper_dry_run(drug_claim_relation = DataModel::DrugClaim)
      total_count = drug_claim_relation.includes(:source)
                        .group(:source)
                        .size
                        .each_with_object({}) { |(k, v), h| h[k.source_db_name] = v}
      pre_count = ungrouped_drug_count
      ActiveRecord::Base.transaction do
        # do stuff
        @drug_grouper = Genome::Groupers::DrugGrouper.new drug_claim_relation
        @drug_grouper.run

        # record result
        @post_grouper_count = ungrouped_drug_count

        # undo stuff
        raise ActiveRecord::Rollback
      end
      rollback_count = ungrouped_drug_count
      puts "Ungrouped drugs before grouper: #{pre_count.values.sum} (%#{pre_count.values.sum / total_count.values.sum.to_f})"
      puts "Ungrouped drugs after grouper: #{@post_grouper_count.values.sum} (%#{@post_grouper_count.values.sum / total_count.values.sum.to_f})"
      return {pre_count: pre_count,
              post_count: @post_grouper_count,
              rollback_count: rollback_count,
              total_counts: total_count,
              grouper: @drug_grouper}
    end

    private
    def self.ungrouped_drug_count
      DataModel::DrugClaim
          .includes(:drug_claim_aliases, :source)
          .where(drug_id: nil)
          .group(:source)
          .size
          .each_with_object({}) { |(k, v), h| h[k.source_db_name] = v}
    end
  end
end
