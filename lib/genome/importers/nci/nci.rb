require 'genome/online_updater'

module Genome; module Importers; module Nci;
  class NewNci < Genome::OnlineUpdater
    attr_reader :file_path
    def initialize(file_path)
      @file_path = file_path
    end

    def get_version
      source_db_version = Date.today.strftime('%d-%B-%Y')
      @new_version = source_db_version
    end

    def import
      remove_existing_source
      create_new_source
      create_interaction_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('NCI')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
          {
              base_url: 'https://wiki.nci.nih.gov/display/cageneindex/The+Cancer+Gene+Index+Gene-Disease+and+Gene-Compound+XML+Documents',
              site_url: 'https://wiki.nci.nih.gov/display/cageneindex',
              citation: 'https://wiki.nci.nih.gov/display/cageneindex',
              source_db_version:  get_version,
              source_type_id: DataModel::SourceType.INTERACTION,
              source_db_name: 'NCI',
              full_name: 'NCI Cancer Gene Index'
          }
      )
    end

    def create_interaction_claims
      CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
        gene_claim = create_gene_claim(row['Gene'], 'CGI Gene Name')
        drug = row['Drug'].upcase
        drug_claim = create_drug_claim(drug, drug, 'NCI Drug Name')
        create_interaction_claim(gene_claim, drug_claim)
      end
    end
  end
end; end; end
