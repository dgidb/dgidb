class DataModel::Gene < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'gene_name_report'
  has_and_belongs_to_many :gene_groups, join_table: :gene_name_group_bridge, foreign_key: :gene_name_report_id, association_foreign_key: :gene_name_group_id
  has_many :gene_alternate_names, foreign_key: :gene_name_report_id
  has_many :gene_categories, foreign_key: :gene_name_report_id
  belongs_to :citation
  has_many :interactions, foreign_key: :gene_name_report_id
  has_many :drugs, through: :interactions

  def source_db_name
    self.citation.source_db_name
  end

  def sort_value
    case self.nomenclature
    when 'ensembl_id'
      return -1
    when 'entrez_id'
      return -2
    else
      return 0
    end
  end

  def original_data_source_url
    base_url = self.citation.base_url
    name = self.name
    case self.citation.source_db_name
    when 'DrugBank'
      [base_url, 'molecules', name, '?as=target'].join('/')
    when 'TTD'
      base_url + 'Detail.asp?ID=' + name
    when 'GO'
      short_name_and_id = self.gene_categories.select {|category| "go_short_name_and_id" == category.category_name}.first.category_value
      short_name_and_id.sub!(/^.*_go/, "")
      base_url + short_name_and_id
    else
      base_url + name
    end
  end
end
