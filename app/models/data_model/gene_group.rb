class DataModel::GeneGroup < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'gene_name_group'
  has_and_belongs_to_many :genes, join_table: :gene_name_group_bridge, foreign_key: :gene_name_group_id, association_foreign_key: :gene_name_report_id

  class << self
    def for_search
      includes(genes: {interactions: {drug: [:drug_alternate_names], citation: [], interaction_attributes: []}})
    end

    def for_gene_categories
      includes(genes: [:gene_alternate_names] )
    end
  end
end
