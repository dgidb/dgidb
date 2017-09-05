require 'genome/online_updater'

module Genome; module OnlineUpdaters; module Cgi;
  class NewCgi
    attr_reader :file_path, :source
    def initialize(file_path)
      @file_path = file_path
    end

    def get_version
      source_db_version = Date.today.strftime("%d-%B-%Y")
      @new_version = source_db_version
    end

    def update
      remove_existing_source
      create_new_source
      create_interaction_claims
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
      CSV.parse(body, :headers => true, :col_sep => '\t') do |row|
        drug_claim = DataModel::DrugClaim.where(
          name: row['Drug'].upcase,
          nomenclature: 'CGI Drug Name',
          primary_name: row['Drug'],
          source_id: source.id
        ).first_or_create

        gene_claim = DataModel::GeneClaim.where(
          name: row['Gene'],
          nomenclature: 'CGI Gene Name',
          source_id: source.id
        ).first_or_create

        interaction_claim = DataModel::InteractionClaim.where(
        gene_claim_id: gene_claim.id,
        drug_claim_id: drug_claim.id,
        source_id: source.id
        ).first_or_create

        row['Source'].split(':').last do |pmid|
            publication = DataModel::Publication.where(
              pmid: pmid
            )
            interaction_claim.publications << publication unless interaction_claim.publications.include? publication
        end
        interaction_claim.save
      end
    end
  end
end; end; end;