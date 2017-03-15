module DataModel
  class GeneAlias < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :gene
    has_and_belongs_to_many :sources

  end
end
