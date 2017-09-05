module DataModel
  class InteractionClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_many :interaction_claim_attributes, inverse_of: :interaction_claim
    belongs_to :gene_claim, inverse_of: :interaction_claims
    belongs_to :drug_claim, inverse_of: :interaction_claims
    belongs_to :source, inverse_of: :interaction_claims, counter_cache: true
    has_and_belongs_to_many :interaction_claim_types, :join_table => 'interaction_claim_types_interaction_claims'
    belongs_to :interaction
    has_and_belongs_to_many :publications

    def self.for_show
      eager_load(:interaction_claim_types, :interaction_claim_attributes, :source, :drug_claim, gene_claim: [:gene, :source])
    end

    def self.for_tsv
      includes(:source, :interaction_claim_types, drug_claim: [:drug], gene_claim: [:gene])
    end

    def drug
      self.drug_claim.drug
    end

    def gene
      self.gene_claim.gene
    end
  end
end
