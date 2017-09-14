module DataModel
  class DrugClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    belongs_to :drug
    has_many :drug_claim_aliases, inverse_of: :drug_claim, dependent: :delete_all
    has_many :interaction_claims, inverse_of: :drug_claim
    has_many :gene_claims, through: :interaction_claims
    belongs_to :source, inverse_of: :drug_claims, counter_cache: true
    has_many :drug_claim_attributes, inverse_of: :drug_claim, dependent: :delete_all
    has_and_belongs_to_many :drug_claim_types, :join_table => 'drug_claim_types_drug_claims'


    def self.for_search
      eager_load(drug: [drug_claims: {interaction_claims: { source: [], gene_claim: [:source, :gene_claim_categories], interaction_claim_types: [], drug_claim: [drug: [drug_claims: [:drug_claim_types]]]}}])
    end

    def self.for_show
      eager_load(:source, :drug_claim_aliases, :drug_claim_attributes)
    end

    def self.for_tsv
      includes(:drug, :source)
    end

    def sort_value
      DrugClaimSortOrder.sort_value(self.nomenclature)
    end

    def names
      @names ||= (self.drug_claim_aliases.pluck(:alias) + [self.name, self.primary_name]).compact.map(&:upcase).to_set
    end

    def cleaned_names
      @cleaned_names ||= names.map { |element| element.gsub(/[^\w_]+/,'')}.to_set
    end

    def original_data_source_url
      base_url = self.source.base_url
      name = self.name
      case self.source.source_db_name
        when 'DrugBank'
          [base_url, 'drugs', name].join('/')
        when 'CIViC', 'DoCM'
          'https://pubchem.ncbi.nlm.nih.gov/search/#collection=compounds&query_type=text&query=' + name
        when 'PharmGKB'
          [base_url, 'drug', name].join('/')
        when 'TTD'
          base_url + 'DRUG.asp?ID=' + name
        when 'TALC'
          'http://www.ncbi.nlm.nih.gov/pubmed/22005529/' #TODO: This is a hack.  Fix it with another db column
                                                         #Alternative: set this as base_url in source.
        when 'TEND'
          'http://www.ncbi.nlm.nih.gov/pubmed/21804595/' #TODO: as above
                                                         #Alternative: as above
        when 'MyCancerGenome', 'CancerCommons', 'ClearityFoundationBiomarkers', 'ClearityFoundationClinicalTrial', 'MyCancerGenomeClinicalTrial'
          base_url
        when 'GuideToPharmacologyInteractions'
          'http://www.guidetopharmacology.org/GRAC/LigandDisplayForward?ligandId=' + name
        when 'ChEMBL'
          'https://www.ebi.ac.uk/chembldb/index.php/compound/inspect/' + name
        else
          base_url + name
      end
    end

  end
end
