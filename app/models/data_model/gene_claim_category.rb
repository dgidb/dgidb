module DataModel
  class GeneClaimCategory < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::TypeEnumeration
    has_and_belongs_to_many :gene_claims

    private
    def self.cache_key
      'all_gene_claim_categories'
    end

    def self.type_column
      :name
    end

    def self.transforms
      [:downcase, [:gsub, ' ', '_']]
    end
  end
end
