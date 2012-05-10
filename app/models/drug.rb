class Drug < ActiveRecord::Base
    self.table_name = 'drug_name_report'
    has_many :drug_alternate_names, foreign_key: :drug_name_report_id
    has_many :drug_categories, foreign_key: :drug_name_report_id
    has_many :interactions, foreign_key: :drug_name_report_id
    has_many :genes, through: :interactions
    belongs_to :citation
end
