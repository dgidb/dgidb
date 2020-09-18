require 'genome/online_updater'

module Genome; module Importers; module FoundationOneGenes;
class FoundationOneGenes < Genome::OnlineUpdater
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
    Utils::Database.delete_source('FoundationOneGenes')
  end

  def create_new_source
    @source ||= DataModel::Source.create(
        {
            base_url: 'https://www.foundationmedicine.com/portfolio',
            citation: 'High-throughput detection of actionable genomic alterations in clinical tumor samples by targeted, massively parallel sequencing. Wagle N, Berger MF, ..., Meyerson M, Gabriel SB, Garraway LA. Cancer Discov. 2012 Jan;2(1):82-93. PMID: 22585170',
            site_url: 'http://www.foundationone.com/',
            source_db_version: Time.new().strftime("%d-%B-%Y"),
            source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'FoundationOneGenes',
            full_name: 'Foundation One',
            license: 'Unknown; data is no longer publicly available from site',
            license_link: 'https://www.foundationmedicine.com/resource/legal-and-privacy',
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
