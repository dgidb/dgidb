require 'genome/online_updater'

module Genome; module Importers; module Pharmgkb;
  class NewPharmgkb < Genome::OnlineUpdater
    attr_reader :file_path, :source

    def initialize(file_path)
      @file_path = file_path
    end

    def get_version
      source_db_version = Date.today.strftime("%d-%B-%Y")
      @new_version = source_db_version
    end

    def import
      remove_existing_source
      create_new_source
      create_interaction_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('PharmGKB')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
          {
              base_url:          'http://www.pharmgkb.org',
              site_url:          'http://www.pharmgkb.org/',
              citation:          "From pharmacogenomic knowledge acquisition to clinical applications: the PharmGKB as a clinical pharmacogenomic biomarker resource. McDonagh EM, Whirl-Carrillo M, Garten Y, Altman RB, Klein TE. Biomark Med. 2011 Dec;5(6):795-806. PMID: 22103613",
              source_db_version:  get_version,
              source_type_id:    DataModel::SourceType.INTERACTION,
              source_db_name:    'PharmGKB',
              full_name:         'PharmGKB - The Pharmacogenomics Knowledgebase'
          }
      )
    end

    def create_interaction_claims
      CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
        next if row['Association'] == 'not associated' || row['Association'] == 'ambiguous'
        if row['Entity1_type'] == 'Gene' and row['Entity2_type'] == 'Chemical'
          drug_name = row['Entity1_name']
          pharmgkb_drug_id = row['Entity1_id']
          gene_name = row['Entity2_name']
          pharmgkb_gene_id = row['Entity2_id']
          drug_claim = create_drug_claim(drug_name, drug_name, 'PharmGKB Drug Name')
          create_drug_claim_alias(drug_claim, 'PharmGKB ID', pharmgkb_drug_id)
          gene_claim = create_gene_claim(gene_name, 'PharmGKB Gene Name')
          create_gene_claim_alias(gene_claim, pharmgkb_gene_id, 'PharmGKB ID')
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          if row['PMIDs'].present?
            add_interaction_claim_publications(interaction_claim, row['Source'])
          end
        else
          if row['Entity1_type'] == 'Chemical' and row['Entity2_type'] == 'Gene'
            gene_name = row['Entity1_name']
            pharmgkb_gene_id = row['Entity1_id']
            drug_name = row['Entity2_name']
            pharmgkb_drug_id = row['Entity2_id']
            drug_claim = create_drug_claim(drug_name, drug_name, 'PharmGKB Drug Name')
            create_drug_claim_alias(drug_claim, 'PharmGKB ID', pharmgkb_drug_id)
            gene_claim = create_gene_claim(gene_name, 'PharmGKB Gene Name')
            create_gene_claim_alias(gene_claim, pharmgkb_gene_id, 'PharmGKB ID')
            interaction_claim = create_interaction_claim(gene_claim, drug_claim)
            if row['PMIDs'].present?
              add_interaction_claim_publications(interaction_claim, row['PMIDs'])
            end
          end
        end
      end
    end



    def add_interaction_claim_publications(interaction_claim, source_string)
      if source_string.include?(';')
        source_string.split(';').each do |value|
          value.split(/[^\d]/).each do |pmid|
            unless pmid.nil? || pmid == ''
              create_interaction_claim_publication(interaction_claim, pmid)
            end
          end
        end
      else
        source_string.split(':').last do |pmid|
          create_interaction_claim_publication(interaction_claim, pmid)
        end
      end
    end
  end
end; end; end