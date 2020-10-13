module DataModel
  class Source < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery

    has_many :gene_claims, inverse_of: :source, dependent: :delete_all
    has_many :drug_claims, inverse_of: :source, dependent: :delete_all
    has_many :interaction_claims, inverse_of: :source, dependent: :delete_all
    has_many :gene_gene_interaction_claims, inverse_of: :source, dependent: :delete_all
    has_and_belongs_to_many :drug_aliases
    has_and_belongs_to_many :drug_attributes
    has_and_belongs_to_many :gene_aliases
    has_and_belongs_to_many :gene_attributes
    has_and_belongs_to_many :interaction_attributes
    has_and_belongs_to_many :source_types
    belongs_to :source_trust_level, inverse_of: :sources

    cache_query :source_names_with_interactions, :all_source_names_with_interactions
    cache_query :potentially_druggable_source_names, :potentially_druggable_source_names
    cache_query :source_names_with_gene_claims, :source_names_with_gene_claims
    cache_query :source_names_with_drug_claims, :source_names_with_drug_claims
    cache_query :source_names_with_category_information, :source_names_with_category_information
    cache_query :all_sources, :all_sources

    def self.all_sources
      all.sort_by { |s| s.full_name.upcase }
    end

    def self.potentially_druggable_source_names
      DataModel::SourceType.find(DataModel::SourceType.POTENTIALLY_DRUGGABLE)
        .sources
        .pluck(:source_db_name)
        .sort
    end

    def self.cancer_only_interaction_source_names
      source_names_with_interactions.sort - disease_agnostic_interaction_source_names
    end

    def self.disease_agnostic_interaction_source_names
      ["ChemblInteractions", "DrugBank", "DTC", "FDA", "GuideToPharmacology", "PharmGKB", "TdgClinicalTrial", "TEND", "TTD"]
    end

    def self.cancer_only_category_source_names
      potentially_druggable_source_names.sort - disease_agnostic_category_source_names
    end

    def self.disease_agnostic_category_source_names
      ["BaderLabGenes", "dGene", "GO", "GuideToPharmacology", "HingoraniCasas", "HopkinsGroom", "HumanProteinAtlas", "IDG", "Pharos", "RussLampel"]
    end

    def self.source_names_with_interactions
      DataModel::SourceType.find(DataModel::SourceType.INTERACTION)
        .sources
        .pluck(:source_db_name)
        .sort
    end

    def self.source_names_with_category_information
      joins(gene_claims: [:gene_claim_categories])
      .uniq
      .pluck(:source_db_name)
      .sort
    end

    def self.source_names_with_gene_claims
      joins(:gene_claims)
        .uniq
        .pluck(:source_db_name)
        .sort_by { |name| GeneClaimSortOrder.sort_value(name) }
    end

    def self.source_names_with_drug_claims
      joins(:drug_claims)
        .uniq
        .pluck(:source_db_name)
        .sort_by { |name| DrugClaimSortOrder.sort_value(name) }
    end

    def self.for_show
      eager_load(:source_types, :source_trust_level)
    end

  end
end
