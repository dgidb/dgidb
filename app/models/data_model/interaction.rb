class DataModel::Interaction < ActiveRecord::Base
    self.table_name = 'drug_gene_interaction_report'
    belongs_to :gene, foreign_key: :gene_name_report_id
    belongs_to :drug, foreign_key: :drug_name_report_id
    has_many :interaction_attributes
    belongs_to :citation
    with_hangoff_table :interaction_attributes, name_column: :name, value_column: :value

    scope :basic,  includes(:interaction_attributes, drug: [:drug_categories])
      .interaction_attributes(interaction_type: 'potentiator', and: {interaction_type: 'na', or: {is_known_action: 'yes'}})


    def types
      self.interaction_attributes.find_all{|attribute| attribute.name == 'interaction_type'}
    end

    def attributes
      self.interaction_attributes.find_all{|attribute| attribute.name != 'interaction_type'}
    end

    #drug.is_withdrawn=0,drug.is_nutraceutical=0,is_potentiator=0,(is_untyped=0 or is_known_action=1)
    def self.basic
      relation = includes(:interaction_attributes, drug: [:drug_categories])
        .interaction_attributes(interaction_type: 'potentiator', and: {interaction_type: 'na', or: {is_known_action: 'yes'}})

        #drug_name_report_id -> id
      relation.merge(DataModel::Drug.drug_categories(drug_group: 'withdrawn', drug_category: 'nutraceutical'))
    end

end
