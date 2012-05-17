class DataModel::InteractionAttribute < ActiveRecord::Base
    self.table_name = 'drug_gene_interaction_report_attribute'
    belongs_to :interaction
end
