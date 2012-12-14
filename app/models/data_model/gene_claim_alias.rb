module DataModel
  class GeneClaimAlias < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :gene_claim

    class << self
      def for_search
        eager_load{[gene_claim, gene_claim.genes,  gene_claim.genes.gene_claims.interaction_claims,  gene_claim.genes.gene_claims.interaction_claims.interaction_claim_attributes,  gene_claim.genes.gene_claims.interaction_claims.drug_claim,  gene_claim.genes.gene_claims.interaction_claims.drug_claim.drug_claim_aliases,  gene_claim.genes.gene_claims.interaction_claims.source ]}
      end

      def for_gene_categories
        eager_load{[gene_claim, gene_claim.genes]}
      end
    end
  end
end
