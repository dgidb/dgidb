require 'genome/importers/importer'
module Genome
  module Importers
    module DrugBank
      class DrugBankImporter < Genome::Importers::Importer
        def initialize(drug_bank_tsv_path, source_db_version, uniprot_mapping_file)
          @tsv_path                     = drug_bank_tsv_path
          @source_db_version            = source_db_version
          @source                       = create_source!
          @uniprot_mapping_file         = uniprot_mapping_file
          @gene_claims                  = []
          @gene_claim_aliases           = []
          @drug_claims                  = []
          @drug_claim_aliases           = []
          @drug_claim_attributes        = []
          @interaction_claims           = []
          @interaction_claim_attributes = []
        end

        private
        def rows
          File.open(@tsv_path).each do |line|
            row = DrugBankRow.new(line)
            yield row if row.valid?(uniprot_mapping: uniprot_mapping)
          end
        end

        def process_file
          rows do |row|
            gene_claim = create_gene_claim_from_row(row)
            drug_claim = create_drug_claim_from_row(row)
            create_interaction_claim_from_row(row, gene_claim, drug_claim)
          end
        end

        def store
          DataModel::GeneClaim.import @gene_claims
          DataModel::GeneClaimAlias.import @gene_claim_aliases
          DataModel::DrugClaim.import @drug_claims
          DataModel::DrugClaimAlias.import @drug_claim_aliases
          DataModel::DrugClaimAttribute.import @drug_claim_attributes
          DataModel::InteractionClaim.import @interaction_claims
          DataModel::InteractionClaimAttribute.import @interaction_claim_attributes
        end

        def create_interaction_claim_from_row(row, gene_claim, drug_claim)
          interaction_claim = create_interaction_claim(drug_claim_id: drug_claim.id,
                                                       gene_claim_id: gene_claim.id,
                                                       known_action_type: row.known_action)
          @interaction_claims << interaction_claim

          create_interaction_claim_attributes(interaction_claim, row)
        end

        def create_interaction_claim_attributes(interaction_claim, row)
          row.target_actions.each do |ta|
            @interaction_claim_attributes << create_interaction_claim_attribute(name: 'Interaction Type',
                                                                                value: ta,
                                                                                interaction_claim_id: interaction_claim.id)
          end
        end

        def create_drug_claim_from_row(row)
          drug_claim = create_drug_claim(name: row.drug_id,
                                         nomenclature: 'DrugBank Drug Identifier',
                                         primary_name: row.drug_name)
          @drug_claims << drug_claim

          create_drug_claim_aliases(drug_claim, row)
          create_drug_claim_attributes(drug_claim, row)
          drug_claim
        end

        def create_drug_claim_aliases(drug_claim, row)
          @drug_claim_aliases << create_drug_claim_alias(alias: row.drug_id,
                                                         nomenclature: 'DrugBank Drug Id',
                                                         drug_claim_id: drug_claim.id)

          @drug_claim_aliases << create_drug_claim_alias(alias: row.drug_name,
                                                         nomenclature: 'Primary Drug Name',
                                                         drug_claim_id: drug_claim.id)

          row.drug_synonyms.reject { |ds| ds == 'N/A' }.each do |synonym|
          @drug_claim_aliases << create_drug_claim_alias(alias: synonym,
                                                         nomenclature: 'Drug Synonym',
                                                         drug_claim_id: drug_claim.id)
          end

          row.drug_brands.reject { |db| db == 'N/A' }.each do |brand|
            matches = (/(?<brand>.+) \((?<manufacturer>.+)\)$/.match(brand)) || {}
            @drug_claim_aliases << create_drug_claim_alias(alias: matches[:brand] || brand,
                                                           nomenclature: matches[:manufacturer] || 'Drug Brand',
                                                           drug_claim_id: drug_claim.id)

          end

          unless row.drug_cas_number == 'N/A'
            @drug_claim_aliases << create_drug_claim_alias(alias: row.drug_cas_number,
                                                           nomenclature: 'CAS Number',
                                                           drug_claim_id: drug_claim.id)
          end

        end

        def create_drug_claim_attributes(drug_claim, row)
          unless row.drug_type == 'N/A'
            @drug_claim_attributes << create_drug_claim_attribute(value: row.drug_type,
                                                           name: 'Drug Type',
                                                           drug_claim_id: drug_claim.id)
          end

          row.drug_categories.reject { |dc| dc == 'N/A' }.each do |dc|
            @drug_claim_attributes << create_drug_claim_attribute(value: dc,
                                                                  name: 'Drug Category',
                                                                  drug_claim_id: drug_claim.id)
          end

          row.drug_groups.reject { |dc| dc == 'N/A' }.each do |dg|
            @drug_claim_attributes << create_drug_claim_attribute(value: dg,
                                                                  name: 'Drug Group',
                                                                  drug_claim_id: drug_claim.id)
          end
        end

        def create_gene_claim_from_row(row)
          gene_claim = create_gene_claim(name: row.gene_id,
                                         nomenclature: 'Drugbank Partner Id')
          @gene_claims << gene_claim
          create_gene_claim_aliases(gene_claim, row)
          gene_claim
        end

        def create_gene_claim_aliases(gene_claim, row)
          unless row.gene_symbol == 'N/A'
            @gene_claim_aliases << create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                                           alias: row.gene_symbol,
                                                           nomenclature: 'Drugbank Gene Name')
          end
          unless row.uniprot_id == 'N/A'
            @gene_claim_aliases << create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                                           alias: row.uniprot_id,
                                                           nomenclature: 'Uniprot Accession')
          end
          unless row.entrez_id == 'N/A'
            @gene_claim_aliases << create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                                           alias: row.entrez_id,
                                                           nomenclature: 'Entrez Gene Id')
          end
          unless row.ensembl_id == 'N/A'
            @gene_claim_aliases << create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                                           alias: row.ensembl_id,
                                                           nomenclature: 'Ensembl Gene Id')
          end
        end

        def uniprot_mapping
          unless @uniprot_mapping
            @uniprot_mapping = YAML.load_file(@uniprot_mapping_file)
          end
          @uniprot_mapping
        end


        def create_source!
          DataModel::Source.new.tap do |s|
            s.id                = SecureRandom.uuid
            s.base_url          = 'http://drugbank.ca/'
            s.site_url          = 'http://drugbank.ca/'
            s.citation          = "DrugBank 3.0: a comprehensive resource for 'omics' research on drugs. Knox C, Law V, ..., Eisner R, Guo AC, Wishart DS. Nucleic Acids Res. 2011 Jan;39(Database issue)1035-41. PMID: 21059682."
            s.source_db_version = @source_db_version
            s.source_type_id    = DataModel::SourceType.INTERACTION
            s.source_db_name    = 'DrugBank'
            s.full_name         = 'DrugBank - Open Data Drug & Drug Target Database'
            s.save
          end
        end
      end
    end
  end
end
