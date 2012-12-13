module DataModel
  class GeneClaimCategory < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_and_belongs_to_many :gene_claims
  end
end
