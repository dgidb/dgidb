class DataModel::InteractionAttribute < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'drug_gene_interaction_report_attribute'
  belongs_to :interaction
end
