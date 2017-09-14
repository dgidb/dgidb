require 'genome/online_updater'

module Genome; module Importers; module DrugBank;
  class NewDrugBank < Genome::OnlineUpdater
    attr_reader :file_path, :source
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      remove_existing_source
      create_source
      import_claims
    end

    def get_version
      File.open('lib/genome/updaters/data/version').readlines.each do |line|
        source, version = line.split("\t")
        if source == 'DrugBank'
          return version.strip
        end
      end
      return nil
    end

    private

    DELIMITER = ';'

    def remove_existing_source
      Utils::Database.delete_source('DrugBank')
    end

    def create_source
      @source = DataModel::Source.where(
        base_url: 'http://www.drugbank.ca',
        site_url: 'http://www.drugbank.ca/',
        citation: "DrugBank 4.0: shedding new light on drug metabolism. Law V, Knox C, Djoumbou Y, Jewison T, Guo AC, Liu Y, Maciejewski A, Arndt D, Wilson M, Neveu V, Tang A, Gabriel G, Ly C, Adamjee S, Dame ZT, Han B, Zhou Y, Wishart DS.Nucleic Acids Res. 2014 Jan 1;42(1):D1091-7. PubMed ID: 24203711",
        source_db_version: get_version,
        source_type_id: DataModel::SourceType.INTERACTION,
        source_db_name: 'DrugBank',
        full_name: 'DrugBank - Open Data Drug & Drug Target Database'
        #source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED
      ).first_or_create
    end

    def import_claims
      CSV.foreach(file_path, :col_sep => "\t", :headers => true) do |row|
        drug_claim = create_drug_claim(row['drug_id'].upcase, row['drug_name'], 'DrugBank Drug Identifier')

        create_drug_claim_alias(drug_claim, row['drug_name'].upcase, 'DrugBank Drug Name')
        row['drug_synonyms'].split(DELIMITER).each do |synonym|
          create_drug_claim_alias(drug_claim, synonym, 'Drug Synonym')
        end
        create_drug_claim_alias(drug_claim, row['drug_cas_number'], 'CAS Number')
        row['drug_brands'].split(DELIMITER).each do |synonym|
          create_drug_claim_alias(drug_claim, synonym, 'Drug Brand')
        end

        create_drug_claim_attribute(drug_claim, 'Drug Type', row['drug_type'])
        row['drug_groups'].split(DELIMITER).each do |group|
          create_drug_claim_attribute(drug_claim, 'Drug Groups', group)
        end
        row['drug_categories'].split(DELIMITER).each do |category|
          create_drug_claim_attribute(drug_claim, 'Drug Categories', category)
        end

        gene_claim = create_gene_claim(row['gene_id'], 'DrugBank Gene Identifier')
        create_gene_claim_alias(gene_claim, row['gene_symbol'], 'DrugBank Gene Name')
        create_gene_claim_alias(gene_claim, row['uniprot_id'], 'UniProt Accession')
        create_gene_claim_alias(gene_claim, row['entrez_id'], 'Entrez Gene Id')
        create_gene_claim_alias(gene_claim, row['ensembl_id'], 'Ensembl Gene Id')

        interaction_claim = create_interaction_claim(gene_claim, drug_claim)
        row['target_actions'].split(DELIMITER).each do |type|
          create_interaction_claim_type(interaction_claim, type)
        end
        row['pmid'].split(DELIMITER).each do |pmid|
          create_interaction_claim_publication(interaction_claim, pmid)
        end
        interaction_claim.save
      end
    end
  end
end; end; end;
