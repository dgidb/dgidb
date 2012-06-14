class DataModel::GeneAlternateName < ActiveRecord::Base
  include UUIDPrimaryKey
  self.table_name = 'gene_name_report_association'
  belongs_to :gene, foreign_key: :gene_name_report_id

  class << self
    def for_search
      includes(gene: {gene_groups: [], interactions: {interaction_attributes: [], drug: [:drug_alternate_names], citation: []}})
    end

    def for_gene_families
      includes(gene: [:gene_groups])
    end
  end
end
