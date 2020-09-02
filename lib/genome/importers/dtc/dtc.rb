require 'genome/online_updater'

module Genome; module Importers; module Dtc;
class DtcImporter < Genome::OnlineUpdater
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
    Utils::Database.delete_source('DTC')
  end

  def create_new_source
    @source ||= DataModel::Source.create(
        {
            base_url: 'https://drugtargetcommons.fimm.fi/',
            site_url: 'https://drugtargetcommons.fimm.fi/',
            citation: 'Drug Target Commons 2.0: a community platform for systematic analysis of drug–target interaction profiles. Tanoli Z, Alam Z, Vähä-Koskela M, Malyutina A, Jaiswal A, Tang J, Wennerberg K, Aittokallio T. Database. 2018.',
            source_db_version:  get_version,
            source_type_id: DataModel::SourceType.INTERACTION,
            source_db_name: 'DTC',
            full_name: 'Drug Target Commons',
            license: 'Creative Commons Attribution-NonCommercial 3.0 (BY-NC)',
            license_link: 'https://academic.oup.com/database/article/doi/10.1093/database/bay083/5096727',
        }
    )
  end

  def create_interaction_claims
    CSV.foreach(file_path, :headers => true) do |row|
      drug_id = row['compound_id']
      drug_name = row['compound_name']
      gene_name = row['gene_names']
      pmid = row['pubmed_id']
      mechanism = row['ep_action_mode']
      unless drug_name.nil? || gene_name.nil?
        drug_claim = create_drug_claim(drug_name, drug_name, 'DTC Drug Name')
        unless drug_id.nil?
          create_drug_claim_alias(drug_claim, drug_id, 'ChEMBL Drug ID')
        end
        gene_name.split(',').each do |indv_gene|
          gene_claim = create_gene_claim(indv_gene, 'DTC Gene Name')
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          unless pmid.nil? || pmid == '""' || pmid == "''" || pmid[0] =='-' || pmid =='15288657'
            create_interaction_claim_publication(interaction_claim, row['pubmed_id'])
          end
          unless mechanism.nil?
            create_interaction_claim_type(interaction_claim, mechanism)
          end
          create_interaction_claim_link(interaction_claim, 'Drug Target Commons Interactions', 'https://drugtargetcommons.fimm.fi/')
        end
      end
    end
    backfill_publication_information()
  end
end
end; end; end
