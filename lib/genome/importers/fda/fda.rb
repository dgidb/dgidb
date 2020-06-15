require 'genome/online_updater'

module Genome; module Importers; module Fda;
class NewFda < Genome::OnlineUpdater
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
    Utils::Database.delete_source('FDA')
  end

  def create_new_source
    @source ||= DataModel::Source.create(
        {
            base_url: 'https://www.fda.gov/drugs/scienceresearch/researchareas/pharmacogenetics/ucm083378.htm',
            site_url: 'https://www.fda.gov/drugs/scienceresearch/researchareas/pharmacogenetics/ucm083378.htm',
            citation: 'https://www.fda.gov/drugs/scienceresearch/researchareas/pharmacogenetics/ucm083378.htm',
            source_db_version:  get_version,
            source_type_id: DataModel::SourceType.INTERACTION,
            source_db_name: 'FDA',
            full_name: 'FDA Pharmacogenomic Biomarkers',
            license: '',
        }
    )
  end

  def create_drug_claims(row, gene_claim, fusion_protein)
    if row['Drug'].include?(',')
      combination_therapy = row['Drug']
      row['Drug'].split(',').each do |drug|
        drug_claim = create_drug_claim(drug, drug, 'FDA Drug Name')
        interaction_claim = create_interaction_claim(gene_claim, drug_claim)
        create_interaction_claim_attribute(interaction_claim, 'Combination therapy', combination_therapy)
        if not fusion_protein.nil?
          create_interaction_claim_attribute(interaction_claim, 'Fusion protein', fusion_protein)
        end
        create_interaction_claim_link(interaction_claim, 'Table of Pharmacogenomic Biomarkers in Drug Labeling', 'https://www.fda.gov/drugs/science-and-research-drugs/table-pharmacogenomic-biomarkers-drug-labeling')
      end
    else
      drug_claim = create_drug_claim(row['Drug'], row['Drug'], 'FDA Drug Name')
      interaction_claim = create_interaction_claim(gene_claim, drug_claim)
      if not fusion_protein.nil?
        create_interaction_claim_attribute(interaction_claim, 'Fusion protein', fusion_protein)
      end
      create_interaction_claim_link(interaction_claim, 'Table of Pharmacogenomic Biomarkers in Drug Labeling', 'https://www.fda.gov/drugs/science-and-research-drugs/table-pharmacogenomic-biomarkers-drug-labeling')
    end
  end

  def create_interaction_claims
    CSV.foreach(file_path, encoding:'iso-8859-1:utf-8', :headers => true, :col_sep => "\t") do |row|
      if row['Gene'].include?(':')
        fusion_protein = row['Gene']
        row['Gene'].split(':').each do |indv_gene|
          gene_claim = create_gene_claim(indv_gene, 'FDA Gene Name')
          create_drug_claims(row, gene_claim, fusion_protein)
        end
      else
        gene_claim = create_gene_claim(row['Gene'], 'FDA Gene Name')
        create_drug_claims(row, gene_claim, nil)
      end
    end
  end
end
end; end; end
