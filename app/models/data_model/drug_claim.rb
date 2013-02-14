module DataModel
  class DrugClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_and_belongs_to_many :drugs
    has_many :drug_claim_aliases, inverse_of: :drug_claim
    has_many :interaction_claims, inverse_of: :drug_claim
    has_many :gene_claims, through: :interaction_claims
    belongs_to :source, inverse_of: :drug_claims
    has_many :drug_claim_attributes, inverse_of: :drug_claim
    has_and_belongs_to_many :drug_claim_types

    def sort_value
      DrugClaimSortOrder.sort_value(self.nomenclature)
    end

    def original_data_source_url
      base_url = self.source.base_url
      name = self.name
      case self.source.source_db_name
      when 'DrugBank'
        [base_url, 'drugs', name].join('/')
      when 'PharmGKB'
        [base_url, 'drug', name].join('/')
      when 'TTD'
        base_url + 'DRUG.asp?ID=' + name
      when 'TALC'
        'http://www.ncbi.nlm.nih.gov/pubmed/22005529/' #TODO: This is a hack.  Fix it with another db column
      when 'TEND'
        'http://www.ncbi.nlm.nih.gov/pubmed/21804595/' #TODO: as above
      else
        base_url + name
      end
    end

  end
end
