module DataModel
  class InteractionClaimType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.inheritance_column = nil

    has_and_belongs_to_many :interaction_claims
  end
end
