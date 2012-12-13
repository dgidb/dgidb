module DataModel
  class GeneGroup < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'gene_name_group'
    has_and_belongs_to_many :genes, join_table: :gene_name_group_bridge, foreign_key: :gene_name_group_id, association_foreign_key: :gene_name_report_id

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
      citation_ids = DataModel::Source.potentially_druggable_sources.map{|c| c.id}
      genes.select{|g| citation_ids.include?(g.citation.id)}
    end

    def display_name
      alternate_names = Maybe(genes).map{|g| g.gene_alternate_names}.flatten.select{|a| a.nomenclature == 'Gene Description'}
      if alternate_names.empty?
          name
      else
          [name, ' (', alternate_names[0].alternate_name, ')'].join("")
      end
    end

  end
end
