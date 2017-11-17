require 'genome/online_updater'

module Genome; module Importers; module Pharmgkb;
class NewPharmgkb < Genome::OnlineUpdater
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
    Utils::Database.delete_source('PharmGKB')
  end

  def create_new_source
    @source ||= DataModel::Source.create(
        {
            base_url: 'http://www.pharmgkb.org',
            site_url: 'http://www.pharmgkb.org/',
            citation: "Pharmacogenomics Knowledge for Personalized Medicine. Whirl-Carrillo M, McDonagh EM, Hebert JM, Gong L, Sangkuhl K, Thorn CF, Altman RB, Klein TE. Clin. Pharmacol. Ther. (2012) 92(4): 414-417. PMID: 22992668",
            source_db_version: get_version,
            source_type_id: DataModel::SourceType.INTERACTION,
            source_db_name: 'PharmGKB',
            full_name: 'PharmGKB - The Pharmacogenomics Knowledgebase'
        }
    )
  end

  def create_interaction_claims
    CSV.foreach(file_path, :headers => true, :col_sep => "\t") do |row|
      if row['Gene'].include?(',')
        row['Gene'].split(',').each do |indv_gene|
          gene_claim = create_gene_claim(indv_gene, 'PharmGKB Gene Name')
          create_gene_claim_alias(gene_claim, ['GeneID'], 'PharmGKB Gene ID')
          drug = row['Chemical'].upcase
          drug_claim = create_drug_claim(drug, drug, 'PharmGKB Drug Name')
          create_drug_claim_alias(drug_claim, row['ChemicalID'], 'PharmGKB Drug ID')
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          unless row['PMIDs'].to_s.empty?
            add_interaction_claim_publications(interaction_claim, row['PMIDs'])
          end
          create_interaction_claim_attribute(interaction_claim, row['Association'], 'Association')
          if row['VariantID'] != 'N/A'
            create_interaction_claim_attribute(interaction_claim, row['VariantID'], 'Reference SNP ID number')
          end
        end
      else
        gene_claim = create_gene_claim(row['Gene'], 'PharmGKB Gene Name')
        create_gene_claim_alias(gene_claim, ['GeneID'], 'PharmGKB Gene ID')
        drug = row['Chemical'].upcase
        drug_claim = create_drug_claim(drug, drug, 'PharmGKB Drug Name')
        create_drug_claim_alias(drug_claim, row['ChemicalID'], 'PharmGKB Drug ID')
        interaction_claim = create_interaction_claim(gene_claim, drug_claim)
        unless row['PMIDs'].to_s.empty?
          add_interaction_claim_publications(interaction_claim, row['PMIDs'])
        end
        create_interaction_claim_attribute(interaction_claim, row['Association'], 'Association')
        if row['VariantID'] != 'N/A'
          create_interaction_claim_attribute(interaction_claim, row['VariantID'], 'Reference SNP ID number')
        end
      end
    end
  end

  def add_interaction_claim_publications(interaction_claim, source_string)
    if source_string.to_s.include?(';')
      source_string.split(';').each do |pmid|
        create_interaction_claim_publication(interaction_claim, pmid)
      end
    else
      create_interaction_claim_publication(interaction_claim, source_string)
    end
  end
end
end; end; end
