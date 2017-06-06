require 'net/http'
module Genome; module OnlineUpdaters; module Civic
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
      source = source
      api_client = ApiClient.new
      api_client.variants.each do |variant|
        api_client.evidence_items_for_variant(variant['id']).select { |ei| importable_eid?(ei) }.each do |ei|
          create_entries_for_evidence_item(variant, ei, source)
        end
      end
    end

    def importable_eid?(evidence_item)
      [
        evidence_item['evidence_type'] == 'Predictive',
        evidence_item['evidence_direction'] == 'Supports',
        evidence_item['evidence_level'] != 'E',
        evidence_item['rating'].present? && evidence_item['rating'] > 2
      ].all?
    end

    def create_entries_for_evidence_item(variant, ei, source)
      ei['drugs'].select { |d| valid_drug?(d) }.each do |drug|
        gc = get_or_create_gene_claim(variant, source)
        dc = get_or_create_drug_claim(drug, source)
        get_or_create_interaction_claim(gc, dc, source, ei)
      end
    end

    def valid_drug?(drug)
      [
        drug['name'].upcase != 'N/A',
        !drug['name'].include?(';'),
      ].all?
    end

    def get_or_create_gene_claim(variant, source)
      DataModel::GeneClaim.where(
        source_id: source.id,
        nomenclature: 'Entrez Gene Symbol',
        name: variant['entrez_name']
      ).first_or_create.tap do |gc|
        DataModel::GeneClaimAlias.where(
          nomenclature: 'Entrez Gene ID',
          alias: variant['entrez_id'].to_s,
          gene_claim_id: gc.id
        ).first_or_create
        DataModel::GeneClaimAlias.where(
          nomenclature: 'CIViC Gene ID',
          alias: variant['gene_id'].to_s,
          gene_claim_id: gc.id
        ).first_or_create
      end
    end

    def get_or_create_drug_claim(drug, source)
      DataModel::DrugClaim.where(
        source_id: source.id,
        primary_name: drug['name'].upcase,
        name: drug['name'].upcase,
        nomenclature: 'CIViC Drug Name',
      ).first_or_create
    end

    def get_or_create_interaction_claim(gc, dc, source, ei)
      DataModel::InteractionClaim.where(
        gene_claim_id: gc.id,
        drug_claim_id: dc.id,
        source_id: source.id,
        known_action_type: 'n/a'
      ).first_or_create.tap do |ic|
        publication = DataModel::Publication.where(pmid: ei['source']['pubmed_id']).first_or_create
        ic.publications << publication unless ic.publications.include?(publication)
        DataModel::InteractionClaimAttribute.where(
          name: 'Interaction Type',
          value: 'N/A',
          interaction_claim_id: ic.id
        ).first_or_create
      end
    end

    def remove_existing_source
      Utils::Database.delete_source('CIViC')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
          source_db_name: 'CIViC',
          source_db_version: new_version,
          base_url: 'https://civic.genome.wustl.edu',
          site_url: 'https://www.civicdb.org',
          citation: 'CIViC: Clinical Interpretations of Variants in Cancer',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          full_name: 'CIViC: Clinical Interpretations of Variants in Cancer'
        }, without_protection: true
      )
    end
  end
end; end; end