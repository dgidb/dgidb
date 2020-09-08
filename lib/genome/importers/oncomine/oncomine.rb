require 'genome/online_updater'

module Genome; module Importers; module Oncomine;
class Oncomine < Genome::OnlineUpdater
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
    Utils::Database.delete_source('Oncomine')
  end

  def create_new_source
    @source ||= DataModel::Source.create(
        {
            base_url: 'https://assets.thermofisher.com/TFS-Assets/LSG/brochures/oncomine-comprehensive-assay-v3-flyer.pdf',
            citation: '"Oncomine Comprehensive Assay v3.", Thermo Fisher Scientific Inc. Accessed 8 Sep 2020. https://assets.thermofisher.com/TFS-Assets/LSG/brochures/oncomine-comprehensive-assay-v3-flyer.pdf',
            site_url: 'https://www.thermofisher.com/us/en/home.html',
            source_db_version: 'v3',
            source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'Oncomine',
            full_name: 'Oncomine Comprehensive Assay',
            license: 'All rights reserved.',
            license_link: 'https://www.thermofisher.com/us/en/home/global/terms-of-use.html',
        }
    )
  end

  def create_gene_claims
    CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
      gene_claim = create_gene_claim(row["Gene"], 'Gene Symbol')
      create_gene_claim_category(gene_claim, 'CLINICALLY ACTIONABLE')
    end
  end
end
end;end;end
