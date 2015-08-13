module DataModel
  class DrugClaimAlias < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :drug_claim, inverse_of: :drug_claim_aliases

    def self.for_search
      eager_load(drug_claim: [drugs: [drug_claims: {interaction_claims: { source: [], drug_claim: [:source], interaction_claim_types: [], gene_claim: [genes: [gene_claims: [:gene_claim_categories]]]}}]])
    end
  end
end
