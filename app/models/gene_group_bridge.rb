class GeneGroupBridge < ActiveRecord::Base
    self.table_name = 'gene_name_group_bridge'
    belongs_to :gene
    belongs_to :gene_group
end
