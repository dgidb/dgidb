module DataModel
  class Gene < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_and_belongs_to_many :gene_claims

    class << self
      def for_search
        eager_load{[gene_claims, gene_claims.interaction_claims, gene_claims.interaction_claims.drug_claim, gene_claims.interaction_claims.drug_claim.drug_claim_aliases, gene_claims.interaction_claims.drug_claim.drug_claim_attributes, gene_claims.interaction_claims.source, gene_claims.interaction_claims.interaction_claim_attributes ]}
      end

      def for_gene_categories
        eager_load{[gene_claims, gene_claims.gene_claim_aliases]}
      end
    end

    def potentially_druggable_genes
      #return Go or other potentially druggable categories
      source_ids = DataModel::Source.potentially_druggable_sources.map{|s| s.id}
      gene_claims.select{|g| source_ids.include?(g.citation.id)}
    end

    def display_name
      alternate_names = Maybe(gene_claims)
        .flat_map{|g| g.gene_claim_aliases}
        .select{|a| a.nomenclature == 'Gene Description'}
      if alternate_names.empty?
          name
      else
          alternate_names[0].alias
      end
    end

  end
end
