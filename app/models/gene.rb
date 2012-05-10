class Gene < ActiveRecord::Base
    self.table_name = 'gene_name_report'
    has_many :gene_group_bridges, foreign_key: :gene_name_report_id
    has_many :gene_groups, through: :gene_group_bridges
    has_many :gene_alternate_names, foreign_key: :gene_name_report_id
    has_many :gene_categories, foreign_key: :gene_name_report_id
    belongs_to :citation
    has_many :interactions, foreign_key: :gene_name_report_id
    has_many :drugs, through: :interactions
end
