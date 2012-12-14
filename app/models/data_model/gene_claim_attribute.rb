module DataModel
  class GeneClaimAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :gene_claim

    class << self
      def for_search
        includes(gene_claim: {genes: [], interaction_claims: {interaction_claim_attributes: [], drug_claim: [:drug_claim_aliases, :drug_claim_attributes], source: []}})
      end

      def for_gene_categories
        includes(gene_claim: [:genes])
      end
    end
  end
end
