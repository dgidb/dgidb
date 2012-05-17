class DataModel::GeneAlternateName < ActiveRecord::Base
    self.table_name = 'gene_name_report_association'
    belongs_to :gene, foreign_key: :gene_name_report_id

    class << self
        def with_genes_and_groups
            includes(gene: [:gene_groups, :interactions])
        end
    end
end
