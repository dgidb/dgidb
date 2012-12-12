module DataModel
  class InteractionClaimType < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_and_belongs_to_many :interaction_claims
  end
end
