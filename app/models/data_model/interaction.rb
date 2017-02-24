module DataModel
  class Interaction < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_many :interaction_claims
    belongs_to :gene
    belongs_to :drug

  end
end
