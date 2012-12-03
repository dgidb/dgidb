module DataModel
  class DrugAlternateName < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'drug_name_report_association'
    belongs_to :drug, foreign_key: :drug_name_report_id, inverse_of: :drug_alternate_names
  end
end
