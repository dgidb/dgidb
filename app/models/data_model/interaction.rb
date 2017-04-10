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
  end
end
