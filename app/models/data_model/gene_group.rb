class DataModel::GeneGroup < ActiveRecord::Base
    self.table_name = 'gene_name_group'
    has_many :gene_group_bridges, foreign_key: :gene_name_group_id
    has_many :genes, through: :gene_group_bridges

    class << self
        def with_genes
            includes(genes: :interactions)
        end
    end
end
