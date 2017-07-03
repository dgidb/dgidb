module DataModel
  class DrugAlias < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :drug
    has_and_belongs_to_many :sources

    def self.for_search
      eager_load(:drug)
    end
  end
end
