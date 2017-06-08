require 'net/http'
module Genome; module OnlineUpdaters; module Docm
  class Updater
    attr_reader :new_version
    def initialize(source_db_version = Date.today.strftime("%d-%B-%Y"))
      @new_version = source_db_version
    end

    def update
      remove_existing_source
      source = create_new_source
      create_interaction_claims(source)
    end

    private
    def create_interaction_claims(source)
      api_client = ApiClient.new
      api_client.variants.each do |variant|
        interaction_information = parse_interaction_information(variant)
        interaction_information.each do |interaction_info|
          gc = get_or_create_gene_claim(variant, source)
          dc = get_or_create_drug_claim(interaction_info, source)
          get_or_create_interaction_claim(gc, dc, interaction_info, variant['diseases'], source)
        end
      end
    end

    def get_or_create_gene_claim(variant, source)
      DataModel::GeneClaim.where(
        source_id: source.id,
        nomenclature: 'DoCM Entrez Gene Symbol',
        name: variant['gene']
      ).first_or_create
      #Entrez Gene Id
    end

    def parse_interaction_information(variant)
      if !variant.key?('meta')
        return []
      end
      fields = variant['meta'].first['Drug Interaction Data']['fields']
      rows = variant['meta'].first['Drug Interaction Data']['rows']
      interaction_information = Set.new()
      rows.each do |row|
        row_hash = {}
        fields.zip(row).each do |name, value|
          row_hash[name] = value
        end
        row_hash['Therapeutic Context'].split(/,|\+|plus/).each do |drug|
          info = row_hash
          info['Therapeutic Context'] = drug
          if valid_drug?(drug)
            interaction_information.add(info)
          end
        end
      end
      return interaction_information
    end

    def valid_drug?(drug_name)
      [
        !drug_name.include?('inhib'),
        !drug_name.include?('HER3'),
        !drug_name.include?('TKI'),
        !drug_name.include?('anti'),
        !drug_name.include?('BRAF'),
        !drug_name.include?('radio'),
        !drug_name.include?('BH3'),
      ].all?
    end

    def get_or_create_drug_claim(interaction_info, source)
      DataModel::DrugClaim.where(
        source_id: source.id,
        primary_name: interaction_info['Therapeutic Context'].upcase,
        name: interaction_info['Therapeutic Context'].upcase,
        nomenclature: 'DoCM Drug Name'
      ).first_or_create
    end

    def get_or_create_interaction_claim(gene_claim, drug_claim, interaction_info, diseases, source)
      DataModel::InteractionClaim.where(
        gene_claim_id: gene_claim.id,
        drug_claim_id: drug_claim.id,
        source_id: source.id,
        known_action_type: 'n/a',
      ).first_or_create.tap do |interaction_claim|
        DataModel::InteractionClaimAttribute.where(
          interaction_claim_id: interaction_claim.id,
          name: 'Clinical Status',
          value: interaction_info['Status']
        ).first_or_create
        DataModel::InteractionClaimAttribute.where(
          interaction_claim_id: interaction_claim.id,
          name: 'Pathway',
          value: interaction_info['Pathway']
        ).first_or_create
        DataModel::InteractionClaimAttribute.where(
          interaction_claim_id: interaction_claim.id,
          name: 'Variant Effect',
          value: interaction_info['Effect']
        ).first_or_create
        diseases.each do |disease|
          DataModel::Publication.where(
            pmid: disease['source_pubmed_id']
          ).first_or_create do |publication|
            interaction_claim.publications << publication
            interaction_claim.save
          end
        end
      end
    end

    def remove_existing_source
      Utils::Database.delete_source('DoCM')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
            base_url: 'http://docm.genome.wustl.edu/',
            citation: 'Manuscript in preparation. Please cite http://docm.genome.wustl.edu/',
            source_db_version: new_version,
            source_type_id: DataModel::SourceType.INTERACTION,
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'DoCM',
            full_name: 'Database of Curated Mutations'
        }, without_protection: true
      )
    end
  end
end; end; end
