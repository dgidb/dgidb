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
        api_client.interactions_for_gene_id(gene)
      end
    end
  end
end