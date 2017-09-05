require 'genome/online_updater'

module Genome; module OnlineUpdaters; module Cgi;
  class Updater < Genome::OnlineUpdater
    attr_reader :new_version
    def initialize(source_db_version = Date.today.strftime("%d-%B-%Y"))
      @new_version = source_db_version
    end

    def update
      remove_existing_source
      create_new_source
      creat_interaction_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('CGI')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
            base_url: 'http://https://www.cancergenomeinterpreter.org/biomarkers',
            site_url: 'https://www.cancergenomeinterpreter.org/',
            citation: 'https://www.cancergenomeinterpreter.org/',
            source_db_version:  @new_version,
            source_type_id: DataModel::SourceType.INTERACTION,
            source_db_name: 'CGI',
            full_name: 'Cancer Genome Interpreter'
        }
      )
    end

    def create_interaction_claims
      api_client = ApiClient.new
      api_client.genes.each do |gene|
        gene_claim = create_gene_claim(gene['Gene'], 'CGI Gene Name')
        create_gene_claim_aliases(gene_claim, gene)
        api_client.interactions_for_gene_id(gene['Gene']).each do |interaction|
          drug_claim = create_drug_claim(interaction['Drug'], interaction['Drug'], ['CGI Drug Name'])
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          create_interaction_claim_publications(interaction_claim, interaction['Source'])
          create_interaction_claim_attributes(interaction_claim, interaction)
        end
      end
    end

    def create_interaction_claim_publications(interaction_claim, publication)
      publication.split(':').last.each do |pmid|
        create_interaction_claim_publication(interaction_claim, pmid)
      end
    end

    def create_interaction_claim_attributes(interaction_claim, interaction)
      ['Primary Tumor type', 'Association', 'Drug Status', 'Evidence Label', 'Alteration'].each do |name|
        create_interaction_claim_attribute(interaction_claim, name, interaction[name])
      end
    end
  end
end; end; end;