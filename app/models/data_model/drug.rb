module DataModel
  class Drug < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_and_belongs_to_many :drug_claims

    cache_query :all_drug_names, :all_drug_names


    def self.for_search
      eager_load(drug_claims: {interaction_claims: { source: [], drug_claim: [:source], interaction_claim_types: [], gene_claim: [genes: [gene_claims: [:gene_claim_categories]]]}})
    end

    def self.all_drug_names
      pluck(:name).sort
    end

  end
end
