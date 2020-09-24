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
          'https://www.pharmgkb.org/search?query=' + name
        when 'TTD'
          ttd_id = self.drug_claim_aliases.first{|a| a.nomenclature == 'TTD Drug ID'}.alias
          [base_url, 'data', 'drug', 'details', ttd_id].join('/')
        when 'TEND'
          'http://www.ncbi.nlm.nih.gov/pubmed/21804595/'
        when 'MyCancerGenome', 'CancerCommons', 'ClearityFoundationBiomarkers', 'ClearityFoundationClinicalTrial', 'MyCancerGenomeClinicalTrial', 'CGI', 'FDA', 'NCI', 'OncoKB', 'TALC', 'HingoraniCasas', 'Tempus', 'COSMIC'
          base_url
        when 'GuideToPharmacology'
          'https://www.guidetopharmacology.org/GRAC/LigandTextSearchForward?searchString=' + name
        when 'ChemblDrugs'
          'https://www.ebi.ac.uk/chembl/compound_report_card/' + name.gsub('chembl:', '')
        when 'JAX-CKB'
          'https://ckb.jax.org/'
        else
          base_url + name
      end
    end

  end
end
