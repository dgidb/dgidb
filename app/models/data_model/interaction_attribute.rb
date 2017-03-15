module DataModel
  class InteractionAttribute < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :interaction
    has_and_belongs_to_many :sources
  end
end
