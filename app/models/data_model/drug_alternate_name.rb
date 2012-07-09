class DataModel::DrugAlternateName < ActiveRecord::Base
  self.table_name = 'drug_name_report_association'
  belongs_to :drug, foreign_key: :drug_name_report_id
end
