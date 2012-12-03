module DataModel
  class DrugCategory < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'drug_name_report_category_association'
    belongs_to :drug, foreign_key: :drug_name_report_id, inverse_of: :drug_categories
  end
end
