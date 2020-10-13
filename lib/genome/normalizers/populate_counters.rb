module Genome
  module Normalizers
    class PopulateCounters
      def self.populate_source_counters
        DataModel::Source.all.each do |source|
          source_db_name = source.source_db_name
          if source_db_name == "Entrez"
            source.gene_claims_count = DataModel::Gene.count
            source.drug_claims_count = 0
            source.interaction_claims_count = 0
            source.gene_gene_interaction_claims_count = 0
            source.interaction_claims_in_groups_count = 0
            source.gene_claims_in_groups_count = source.gene_claims_count
            source.drug_claims_in_groups_count = 0
          else  
            source.gene_claims_count = source.gene_claims.pluck(:id).size
            source.drug_claims_count = source.drug_claims.pluck(:id).size
            source.interaction_claims_count = source.interaction_claims.pluck(:id).size
            source.gene_gene_interaction_claims_count = 0
            source.interaction_claims_in_groups_count = relation_in_groups_for_source(:interaction_claims, source)
            source.gene_claims_in_groups_count = relation_in_groups_for_source(:gene_claims, source)
            source.drug_claims_in_groups_count = relation_in_groups_for_source(:drug_claims, source)
          end
          source.save
        end
      end

      private
      def self.relation_in_groups_for_source(relation, source)
        source.send(relation)
          .joins("#{relation.to_s.split('_').first}".to_sym).size
      end
    end
  end
end
