class DataModel::GeneCategory < ActiveRecord::Base
    self.table_name = 'gene_name_report_category_association'
    belongs_to :gene, foreign_key: :gene_name_report_id
end
