module DataModel
  class GeneClaimAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :gene_claim

    class << self
      def for_search
        includes(gene: {gene_groups: [], interactions: {interaction_attributes: [], drug: [:drug_alternate_names, :drug_categories], citation: []}})
      end

      def for_gene_categories
        includes(gene: [:gene_groups])
      end
    end
  end
end
