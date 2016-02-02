module DataModel
  class Drug < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_and_belongs_to_many :drug_claims

    cache_query :all_drug_names, :all_drug_names


    def self.for_search
      eager_load(drug_claims: {interaction_claims: { source: [], gene_claim: [:source, :gene_claim_categories], interaction_claim_types: [], drug_claim: [drugs: [drug_claims: [:drug_claim_types]]]}})
    end

    def self.for_show
      eager_load(drug_claims: [:drug_claim_aliases, :drug_claim_attributes, :drugs, source: [:source_type]])
    end

    def self.all_drug_names
      pluck(:name).sort
    end

  end
end
