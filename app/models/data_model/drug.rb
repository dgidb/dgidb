module DataModel
  class Drug < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_and_belongs_to_many :drug_claims
  end
end
