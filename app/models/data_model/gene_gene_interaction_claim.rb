module DataModel
  class GeneGeneInteractionClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :source, inverse_of: :gene_gene_interaction_claim, dependent: :delete
    belongs_to :interacting_gene, class_name: 'DataModel::Gene'
    belongs_to :gene
    has_many :gene_gene_interaction_claim_attributes, inverse_of: :gene_gene_interaction_claim,
      dependent: :delete_all
  end
end

