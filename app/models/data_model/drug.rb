class DataModel::Drug < ActiveRecord::Base
  self.table_name = 'drug_name_report'
  has_many :drug_alternate_names, foreign_key: :drug_name_report_id
  has_many :interactions, foreign_key: :drug_name_report_id
  has_many :genes, through: :interactions
  belongs_to :citation
  has_many :drug_categories, foreign_key: :drug_name_report_id

  def original_data_source_url
    base_url = self.citation.base_url
    name = self.name
    case self.citation.source_db_name
    when 'DrugBank'
      [base_url, 'drugs', name].join('/')
    when 'TTD'
      base_url + 'DRUG.asp?ID=' + name
    else
      base_url + name
    end
  end

end
