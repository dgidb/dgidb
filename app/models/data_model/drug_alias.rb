module DataModel
  class DrugAlias < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :drug
    has_and_belongs_to_many :sources

  end
end
