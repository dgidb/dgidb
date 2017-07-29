module Genome; module Importers; module DrugBank;
  class NewDrugBank
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
        drug_claim = DataModel::DrugClaim.where(
          name: row['drug_id'].upcase,
          nomenclature: 'DrugBank Drug Identifier',
          primary_name: row['drug_name'],
          source_id: source.id
        ).first_or_create

        add_drug_claim_alias(drug_claim.id, row['drug_name'].upcase, 'DrugBank Drug Name')
        row['drug_synonyms'].split(',').each do |synonym|
          add_drug_claim_alias(drug_claim.id, synonym, 'Drug Synonym')
        end
        add_drug_claim_alias(drug_claim.id, row['drug_cas_number'], 'CAS Number')
        row['drug_brands'].split(',').each do |synonym|
          add_drug_claim_alias(drug_claim.id, synonym, 'Drug Brand')
        end

        add_drug_claim_attribute(drug_claim.id, 'Drug Type', row['drug_type'])
        row['drug_groups'].split(',').each do |group|
          add_drug_claim_attribute(drug_claim.id, 'Drug Groups', group)
        end
        row['drug_categories'].split(',').each do |category|
          add_drug_claim_attribute(drug_claim.id, 'Drug Categories', category)
        end

        gene_claim = DataModel::GeneClaim.where(
          name: row['gene_id'],
          nomenclature: 'DrugBank Gene Identifier',
          source_id: source.id
        ).first_or_create
        add_gene_claim_alias(gene_claim.id, row['gene_symbol'], 'DrugBank Gene Name')
        add_gene_claim_alias(gene_claim.id, row['uniprot_id'], 'UniProt Accession')
        add_gene_claim_alias(gene_claim.id, row['entrez_id'], 'Entrez Gene Id')
        add_gene_claim_alias(gene_claim.id, row['ensembl_id'], 'Ensembl Gene Id')

        interaction_claim = DataModel::InteractionClaim.where(
          gene_claim_id: gene_claim.id,
          drug_claim_id: drug_claim.id,
          source_id: source.id
        ).first_or_create
        row['target_actions'].split(',').each do |type|
          claim_type = DataModel::InteractionClaimType.where(
            type: type
          ).first_or_create
          interaction_claim.interaction_claim_types << claim_type unless interaction_claim.interaction_claim_types.include? claim_type
        end
        row['pmid'].split(',').each do |pmid|
          publication = DataModel::Publication.where(
            pmid: pmid
          ).first_or_create
          interaction_claim.publications << publication unless interaction_claim.publications.include? publication
        end
        interaction_claim.save
      end
    end

    def add_drug_claim_alias(drug_claim_id, synonym, nomenclature)
      DataModel::DrugClaimAlias.where(
        alias: synonym,
        nomenclature: nomenclature,
        drug_claim_id: drug_claim_id,
      ).first_or_create
    end

    def add_drug_claim_attribute(drug_claim_id, name, value)
      DataModel::DrugClaimAttribute.where(
        name: name,
        value: value,
        drug_claim_id: drug_claim_id,
      ).first_or_create
    end

    def add_gene_claim_alias(gene_claim_id, synonym, nomenclature)
      DataModel::GeneClaimAlias.where(
        alias: synonym,
        nomenclature: nomenclature,
        gene_claim_id: gene_claim_id,
      ).first_or_create
    end

  end
end; end; end;
