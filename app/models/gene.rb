class Gene < ActiveRecord::Base
    self.table_name = 'gene_name_report'
    has_many :gene_group_bridges, foreign_key: :gene_name_report_id
    has_many :gene_groups, through: :gene_group_bridges
    has_many :gene_alternate_names, foreign_key: :gene_name_report_id
    has_many :gene_categories, foreign_key: :gene_name_report_id
    belongs_to :citation
    has_many :interactions, foreign_key: :gene_name_report_id
    has_many :drugs, through: :interactions

    def source_id
      self.name.sub(/^ENTREZ_G/, "").sub(/^DGBNK_G/, "")
    end

    def original_data_source_url
      base_url = self.citation.base_url
      name = self.source_id
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
