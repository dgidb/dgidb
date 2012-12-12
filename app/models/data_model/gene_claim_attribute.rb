module DataModel
  class GeneCategory < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'gene_name_report_category_association'
    belongs_to :gene, foreign_key: :gene_name_report_id, inverse_of: :gene_categories

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
