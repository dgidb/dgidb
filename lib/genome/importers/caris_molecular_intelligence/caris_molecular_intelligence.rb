require 'genome/online_updater'

module Genome; module Importers; module CarisMolecularIntelligence;
  class CarisMolecularIntelligence < Genome::OnlineUpdater
    attr_reader :file_path, :source

    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_new_source
      create_gene_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('CarisMolecularIntelligence')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
          {
              base_url: 'https://www.carislifesciences.com/molecular-profiling-technology/',
              site_url: 'http://www.carismolecularintelligence.com/',
              citation: 'http://www.carismolecularintelligence.com/',
              source_db_version: Time.new().strftime("%d-%B-%Y"),
              source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
              source_db_name: 'CarisMolecularIntelligence',
              full_name: 'Caris Molecular Intelligence',
              source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
              license: 'Unknown',
              license_link: 'https://www.carismolecularintelligence.com/contact-us/',
          }
      )
    end

    def create_gene_claims
      CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
        gene_claim = create_gene_claim(row["Gene"], 'Gene Symbol')
        gene_claim.gene_claim_categories << 'CLINICALLY ACTIONABLE'
      end
    end
  end
end;end;end