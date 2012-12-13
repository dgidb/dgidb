module DataModel
  class GeneClaimAlias < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :gene_claim

    class << self
      def for_search
        eager_load{[gene, gene.gene_groups,  gene.gene_groups.genes.interactions,  gene.gene_groups.genes.interactions.interaction_attributes,  gene.gene_groups.genes.interactions.drug,  gene.gene_groups.genes.interactions.drug.drug_alternate_names,  gene.gene_groups.genes.interactions.citation ]}
      end

      def for_gene_categories
        eager_load{[gene, gene.gene_groups]}
      end
    end
  end
end
