module DataModel
  class Drug < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_many :drug_claims
    has_many :interactions
    has_many :drug_aliases
    has_many :drug_attributes

    before_save :claims_to_aliases
    before_save :populate_flags

    cache_query :all_drug_names, :all_drug_names


    def self.for_search
      eager_load(drug_claims: {interaction_claims: { source: [], gene_claim: [:source, :gene_claim_categories], interaction_claim_types: [], drug_claim: [drug: [drug_claims: [:drug_claim_types]]]}})
    end

    def self.for_show
      eager_load(drug_claims: [:drug_claim_aliases, :drug_claim_attributes, :drug, source: [:source_type]])
    end

    def self.all_drug_names
      pluck(:name).sort
    end

    private
    def populate_flags
      nil # TODO: Populate the Drug table flags
    end

    def claims_to_aliases
      nil
    end

  end
end