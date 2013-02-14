module Genome
  module Normalizers
    class PopulateCounters
      def self.populate_source_counters
        DataModel::Source.all.each do |source|
          source.gene_claims_count = source.gene_claims.pluck(:id).size
          source.drug_claims_count = source.drug_claims.pluck(:id).size
          source.interaction_claims_count = source.interaction_claims.pluck(:id).size
          #TODO support interaction groups when they exist
          #source.interaction_claims_in_groups = relation_in_groups_for_source(:interaction_claims, source)
          source.interaction_claims_in_groups_count = 0
          source.gene_claims_in_groups_count = relation_in_groups_for_source(:gene_claims, source)
          source.drug_claims_in_groups_count = relation_in_groups_for_source(:drug_claims, source)
          source.save
        end
      end

      private
      def self.relation_in_groups_for_source(relation, source)
        source.send(relation)
          .joins("#{relation.to_s.split('_').first.pluralize}".to_sym).size
      end
    end
  end
end
