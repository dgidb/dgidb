require 'net/http'
require 'genome/online_updater'

module Genome; module OnlineUpdaters; module Civic
  class Updater < Genome::OnlineUpdater
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
        gc = create_gene_claim(variant['entrez_name'], 'Entrez Gene Symbol')
        create_gene_claim_aliases(gc, variant)
        dc = create_drug_claim(drug['name'].upcase, drug['name'].upcase, 'CIViC Drug Name')
        ic = create_interaction_claim(gc, dc)
        if ei['source']['citation_id'].present? and ei['source']['source_type'] == 'PubMed'
          create_interaction_claim_publication(ic, ei['source']['citation_id'])
        end
        create_interaction_claim_attribute(ic, 'Interaction Type', 'N/A')
        create_interaction_claim_link(ic, ei['name'], "https://civicdb.org/links/evidence/#{ei['id']}")
      end
    end

    def valid_drug?(drug)
      [
        drug['name'].upcase != 'N/A',
        !drug['name'].include?(';'),
      ].all?
    end

    def create_gene_claim_aliases(gc, variant)
      create_gene_claim_alias(gc, variant['entrez_id'].to_s, 'Entrez Gene ID')
      create_gene_claim_alias(gc, variant['gene_id'].to_s, 'CIViC Gene ID')
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
          citation: 'CIViC: Clinical Interpretation of Variants in Cancer',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          full_name: 'CIViC: Clinical Interpretation of Variants in Cancer',
          license: 'Creative Commons Public Domain Dedication (CC0 1.0 Universal)',
          license_url: 'https://docs.civicdb.org/en/latest/about/faq.html#how-is-civic-licensed',
        }
      )
    end
  end
end; end; end
