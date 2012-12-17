module DataModel
  class GeneClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_and_belongs_to_many :genes
    has_and_belongs_to_many :gene_claim_categories
    has_many :gene_claim_aliases, inverse_of: :gene_claim
    has_many :gene_claim_attributes, inverse_of: :gene_claim
    belongs_to :source, inverse_of: :gene_claims
    has_many :interaction_claims, inverse_of: :gene_claim
    has_many :drug_claims, through: :interaction_claims

    class << self
      def for_search
        eager_load{[genes, genes.gene_claims.interaction_claims, interaction_claims, interaction_claims.drug_claim, interaction_claims.drug_claim.drug_claim_aliases, interaction_claims.drug_claim.drug_claim_attributes, interaction_claims.source, drug_claims, drug_claims.drug_claim_aliases, genes.gene_claims.interaction_claims.drug_claim, genes.gene_claims.interaction_claims.drug_claim.drug_claim_aliases, genes.gene_claims.interaction_claims.drug_claim.drug_claim_attributes, genes.gene_claims.interaction_claims.source, source ]}
      end

      def for_gene_categories
        eager_load{[genes]}
      end
    end

    def source_db_name
      self.source.source_db_name
    end

    def sort_value
      case self.source_db_name
      when 'Ensembl'
        return -1
      when 'Entrez'
        return -2
      else
        return 0
      end
    end

    def original_data_source_url
      base_url = self.source.base_url
      name = self.name
      case self.source.source_db_name
      when 'DrugBank'
        [base_url, 'molecules', name, '?as=target'].join('/')
      when 'PharmGKB'
        [base_url, 'gene', name].join('/')
      when 'TTD'
        base_url + 'Detail.asp?ID=' + name
      when 'GO'
        base_url.gsub(/XXXXXXXX/, name)
      else
        base_url + name
      end
    end
  end
end
