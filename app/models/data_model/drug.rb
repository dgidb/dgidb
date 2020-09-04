module DataModel
  class Drug < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_many :drug_claims, before_add: :update_anti_neoplastic_add, before_remove: :update_anti_neoplastic_remove
    has_many :interactions
    has_many :drug_aliases
    has_many :drug_attributes
    belongs_to :chembl_molecule

    before_create :populate_flags

    cache_query :all_drug_names, :all_drug_names


    def self.for_search
      eager_load(:interactions)
        .includes(interactions: [:gene, :interaction_types, :publications, :sources])
    end

    def self.for_show
      eager_load(drug_claims: [:drug_claim_aliases, :drug_claim_attributes, :drug, source: [:source_type]])
    end

    def self.all_drug_names
      order('name ASC').pluck(:name)
    end

    def update_anti_neoplastic
      # self.update_anti_neoplastic_remove nil
      self.anti_neoplastic = (self.class.anti_neoplastic_source_names & self.drug_claims.map { |dc| dc.source.source_db_name }.to_set).any?
      self.save!
    end

    private
    def populate_flags
      self.approved = false
      self.immunotherapy = false
      self.anti_neoplastic = false
    end

    def update_anti_neoplastic_add(drug_claim)
      self.anti_neoplastic ||= self.class.anti_neoplastic_source_names.member? drug_claim.source.source_db_name
      self.save!
    end

    def update_anti_neoplastic_remove(drug_claim)
      self.anti_neoplastic = (self.class.anti_neoplastic_source_names & self.drug_claims.map { |dc| dc.source.source_db_name }.to_set).any?
      self.save!
    end

    def self.anti_neoplastic_source_names
      @@anti_neoplastic_source_names ||= %w[TALC ClearityFoundationClinicalTrial ClearityFoundationBiomarkers CancerCommons
                                      MyCancerGenome CIViC MyCancerGenomeClinicalTrial].to_set
    end

  end
end
