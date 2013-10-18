module DataModel
  class Drug < ::ActiveRecord::Base
    has_and_belongs_to_many :drug_claims
  end
end
