module DataModel
  class Gene < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_and_belongs_to_many :gene_claims

    class << self
      def for_search
        eager_load{[genes, genes.interactions, genes.interactions.drug, genes.interactions.drug.drug_alternate_names, genes.interactions.drug.drug_categories, genes.interactions.citation, genes.interactions.interaction_attributes ]}
      end

      def for_gene_categories
        eager_load{[genes, genes.gene_alternate_names]}
      end
    end

    def potentially_druggable_genes
      #return Go or other potentially druggable categories
      source_ids = DataModel::Source.potentially_druggable_sources.map{|s| s.id}
      genes.select{|g| source_ids.include?(g.citation.id)}
    end

    def display_name
      alternate_names = Maybe(gene_claims)
        .flat_map{|g| g.gene_claim_aliases}
        .select{|a| a.nomenclature == 'Gene Description'}
      if alternate_names.empty?
          name
      else
          [name, ' (', alternate_names[0].alias, ')'].join("")
      end
    end

  end
end
