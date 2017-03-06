module DataModel
  class DrugAttribute < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :drug
    belongs_to :source
  end
end
