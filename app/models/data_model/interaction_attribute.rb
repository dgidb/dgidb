module DataModel
  class InteractionAttribute < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    self.table_name = 'drug_gene_interaction_report_attribute'
    belongs_to :interaction, inverse_of: :interaction_attributes
  end
end
