module DataModel
  class DrugGroup < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'drug_name_group'
    has_and_belongs_to_many :drugs, join_table: :drug_name_group_bridge, foreign_key: :drug_name_group_id, association_foreign_key: :drug_name_report_id
  end
end
