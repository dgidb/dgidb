module DataModel
  class Interaction < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_many :interaction_claims
    belongs_to :gene
    belongs_to :drug
    has_and_belongs_to_many :interaction_types,
      :join_table => "interaction_types_interactions",
      :class_name => "InteractionClaimType"
    has_many :interaction_attributes
    has_and_belongs_to_many :publications
    has_and_belongs_to_many :sources

    def source_names
      self.sources.pluck(:source_db_name).uniq
    end

    def type_names
      self.interaction_types.pluck(:type).uniq
    end

    def pmids
      self.publications.pluck(:pmid).uniq
    end

    def directionality
      self.interaction_types.pluck(:directionality).reject{ |d| d.nil? }.uniq
    end

    def self.for_tsv
      eager_load(:gene, :drug, :interaction_types, :sources)
    end
  end
end
