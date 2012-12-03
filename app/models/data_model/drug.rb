module DataModel
  class Drug < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    self.table_name = 'drug_name_report'
    has_and_belongs_to_many :drug_groups, join_table: :drug_name_group_bridge, foreign_key: :drug_name_report_id, association_foreign_key: :drug_name_group_id
    has_many :drug_alternate_names, foreign_key: :drug_name_report_id, inverse_of: :drug
    has_many :interactions, foreign_key: :drug_name_report_id, inverse_of: :drug
    has_many :genes, through: :interactions
    belongs_to :citation, inverse_of: :drugs
    has_many :drug_categories, foreign_key: :drug_name_report_id, inverse_of: :drug

    def sort_value
      case self.nomenclature
      when 'pubchem'
        return -1
      else
        return 0
      end
    end

    def original_data_source_url
      base_url = self.citation.base_url
      name = self.name
      case self.citation.source_db_name
      when 'DrugBank'
        [base_url, 'drugs', name].join('/')
      when 'PharmGKB'
        [base_url, 'drug', name].join('/')
      when 'TTD'
        base_url + 'DRUG.asp?ID=' + name
      when 'TALC'
        'http://www.ncbi.nlm.nih.gov/pubmed/22005529/' #TODO: This is a hack.  Fix it with another db column
      else
        base_url + name
      end
    end

  end
end
