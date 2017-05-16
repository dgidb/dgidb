module DataModel
  class GeneAttribute < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :gene
    has_and_belongs_to_many :sources
  end
end
