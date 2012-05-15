class GeneGroupBridge < ActiveRecord::Base
    self.table_name = 'gene_name_group_bridge'
    belongs_to :gene, foreign_key: :gene_name_report_id
    belongs_to :gene_group, foreign_key: :gene_name_group_id
end
