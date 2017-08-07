module Genome; module OnlineUpdaters; module Oncokb;
  class Updater
    attr_reader :new_version
    def initialize(source_db_version = Date.today.strftime("%d-%B-%Y"))
      @new_version = source_db_version
    end

    def update
      remove_existing_source
      source = create_new_source
      create_interaction_claims(source)
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('OncoKB')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
        {
          source_db_name: 'OncoKB',
          source_db_version: new_version,
          base_url: 'http://oncokb.org/',
          site_url: 'http://oncokb.org/',
          citation: 'OncoKB: A Precision Oncology Knowledge Base. Chakravarty D, Gao J, Phillips S, et. al. JCO Precision Oncology 2017 :1, 1-16',
          source_type_id: DataModel::SourceType.INTERACTION,
          full_name: 'OncoKB: A Precision Oncology Knowledge Base',
        }
      )
    end

    def create_interaction_claims(source)
      api_client = ApiClient.new
      genes = get_genes(api_client)
      drugs = get_drugs(api_client)
      api_client.variants.each do |variant|
        gene = genes[variant['gene']]
        gene_claim = create_gene_claim(gene, source)

        variant['drugs'].split(', ').each do |drug_name|
          if drug_name.include? '+'
            combination_drug_name = drug_name
            combination_drug_name.split(' + ').each do |individual_drug_name|
              if valid_drug?(individual_drug_name)
                puts(individual_drug_name)
                drug = drugs[individual_drug_name]
                drug_claim = create_drug_claim(drug['drugName'], 'OncoKB Drug Name', source)
                interaction_claim = create_interaction_claim(gene_claim.id, drug_claim.id, source)
                DataModel::InteractionClaimAttribute.where(
                  name: 'combination therapy',
                  value: combination_drug_name,
                  interaction_claim_id: interaction_claim.id,
                ).first_or_create
                add_interaction_claim_publications(interaction_claim, variant['pmids'])
              end
            end
          else
            if valid_drug?(drug_name)
              puts(drug_name)
              drug = drugs[drug_name]
              drug_claim = create_drug_claim(drug['drugName'], 'OncoKB Drug Name', source)
              interaction_claim = create_interaction_claim(gene_claim.id, drug_claim.id, source)
              add_interaction_claim_publications(interaction_claim, variant['pmids'])
            end
          end
        end
      end
    end

    def get_genes(api_client)
      api_client.genes.each_with_object({}) do |g, h|
        h[g['hugoSymbol']] = g
      end
    end

    def get_drugs(api_client)
      api_client.drugs.each_with_object({}) do |d, h|
        h[d['drugName']] = d
      end
    end

    def create_gene_claim(gene, source)
      gene_claim =  DataModel::GeneClaim.where(
        name: gene['hugoSymbol'],
        nomenclature: 'OncoKB Gene Name',
        source_id: source.id,
      ).first_or_create
      create_gene_claim_alias(gene_claim.id, gene['entrezGeneId'], 'OncoKB Entrez Id')
      gene['geneAliases'].each do |synonym|
        create_gene_claim_alias(gene_claim.id, synonym, 'OncoKB Gene Synonym')
      end
      gene_claim
    end

    def create_gene_claim_alias(gene_claim_id, synonym, nomenclature)
      DataModel::GeneClaimAlias.where(
        alias: synonym,
        nomenclature: nomenclature,
        gene_claim_id: gene_claim_id,
      ).first_or_create
    end

    def valid_drug?(drug_name)
      ['Radiation'].none? { |name| drug_name.include?(name)  }
    end

    def create_drug_claim(name, nomenclature, source)
      DataModel::DrugClaim.where(
        name: name,
        nomenclature: nomenclature,
        source_id: source.id,
      ).first_or_create
    end

    def create_interaction_claim(gene_claim_id, drug_claim_id, source)
      DataModel::InteractionClaim.where(
        gene_claim_id: gene_claim_id,
        drug_claim_id: drug_claim_id,
        source_id: source.id,
      ).first_or_create
    end

    def add_interaction_claim_publications(interaction_claim, pmids)
      pmids.split(', ').each do |pmid|
        publication = DataModel::Publication.where(
          pmid: pmid
        ).first_or_create
        interaction_claim.publications << publication unless interaction_claim.publications.include? publication
      end
    end
  end
end; end; end
