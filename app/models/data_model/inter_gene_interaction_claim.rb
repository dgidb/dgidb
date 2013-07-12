module DataModel
  class InterGeneInteractionClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_many :inter_gene_interaction_claim_attributes, inverse_of: :inter_gene_interaction_claim, dependent: :delete_all
    belongs_to :source, inverse_of: :inter_gene_interaction_claims, dependent: :delete
    belongs_to :left_gene, class_name: 'DataModel::Gene'
    belongs_to :right_gene, class_name: 'DataModel::Gene'
  end
end

