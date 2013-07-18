module DataModel
  class GeneGeneInteractionClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :source, inverse_of: :gene_gene_interaction_claim, dependent: :delete
    belongs_to :interacting_gene, class_name: 'DataModel::Gene'
    belongs_to :gene
    has_many :attributes, inverse_of: :gene_gene_interaction_claim,
      class_name: 'DataModel::GeneGeneInteractionClaimAttribute',
      dependent: :delete_all
  end
end

