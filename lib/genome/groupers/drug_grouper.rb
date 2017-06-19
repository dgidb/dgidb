module Genome
  module Groupers
    class DrugGrouper
      @alt_to_chembl = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_other = Hash.new() {|hash, key| hash[key] = []}

      def self.run
        begin
          newly_added_claims_count = 0
          drug_claims_not_in_groups.find_in_batches do |claims|
            ActiveRecord::Base.transaction do
              grouped_claims = add_members(claims)
              newly_added_claims_count += grouped_claims.length
              if grouped_claims.length > 0
                add_attributes(grouped_claims)
              end
            end
          end
        end until newly_added_claims_count == 0
      end

      def add_members(claims)
        grouped_claims = []
        claims.each do |drug_claim|
          grouped_claims << group_drug_claim(drug_claim)
        end
        return grouped_claims.compact
      end

      def group_drug_claim(drug_claim)
        # check drug names
        #   - against claim name
        #   - against claim alias
        # check drug aliases
        #   - against claim name
        #   - against claim alias
        # check molecule
      end
    end
  end
end
