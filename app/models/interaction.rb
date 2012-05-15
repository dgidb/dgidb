class Interaction < ActiveRecord::Base
    self.table_name = 'drug_gene_interaction_report'
    belongs_to :gene, foreign_key: :gene_name_report_id
    belongs_to :drug, foreign_key: :drug_name_report_id
    has_many :interaction_attributes
    belongs_to :citation

    def types
      self.interaction_attributes.find_all{|attribute| attribute.name == 'interaction_type'}
    end

    def attributes
      self.interaction_attributes.find_all{|attribute| attribute.name != 'interaction_type'}
    end
end
