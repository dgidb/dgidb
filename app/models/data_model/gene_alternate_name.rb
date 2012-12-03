module DataModel
  class GeneAlternateName < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'gene_name_report_association'
    belongs_to :gene, foreign_key: :gene_name_report_id, inverse_of: :gene_alternate_names

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
