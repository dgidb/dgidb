module DataModel
  class GeneClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    has_and_belongs_to_many :genes
    has_many :gene_claim_aliases, inverse_of: :gene_claim
    has_many :gene_claim_attributes, inverse_of: :gene_claim
    belongs_to :source, inverse_of: :gene_claims
    has_many :interaction_claims, inverse_of: :gene_claim
    has_many :drug_claims, through: :interaction_claims

    class << self
      def for_search
        eager_load{[gene_groups, gene_groups.genes.interactions, interactions, interactions.drug, interactions.drug.drug_alternate_names, interactions.drug.drug_categories, interactions.citation, drugs, drugs.drug_alternate_names, drugs.drug_categories,gene_groups.genes.interactions.drug, gene_groups.genes.interactions.drug.drug_alternate_names, gene_groups.genes.interactions.drug.drug_categories, gene_groups.genes.interactions.citation, citation ]}
      end

      def for_gene_categories
        eager_load{[gene_groups]}
      end
    end

    def source_db_name
      self.citation.source_db_name
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
      base_url = self.citation.base_url
      name = self.name
      case self.citation.source_db_name
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
