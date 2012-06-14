class DataModel::GeneGroup < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'gene_name_group'
  has_many :gene_group_bridges, foreign_key: :gene_name_group_id
  has_many :genes, through: :gene_group_bridges

  class << self
    def for_search
      includes(genes: {interactions: {drug: [:drug_alternate_names], citation: [], interaction_attributes: []}})
    end

    def for_gene_families
      includes(genes: [:gene_alternate_names] )
    end
  end
end
