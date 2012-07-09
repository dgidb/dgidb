class DataModel::DrugCategory < ActiveRecord::Base
  self.table_name = 'drug_name_report_category_association'
  belongs_to :drug, foreign_key: :drug_name_report_id
end
