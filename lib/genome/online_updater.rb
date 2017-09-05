module Genome
  class OnlineUpdater
    def create_gene_claim(gene_name, nomenclature)
      DataModel::GeneClaim.where(
        name: gene_name,
        nomenclature: nomenclature,
        source_id: @source.id
      ).first_or_create
    end

    def create_gene_claim_alias(gene_claim, synonym, nomenclature)
      DataModel::GeneClaimAlias.where(
        alias: synonym,
        nomenclature: nomenclature,
        gene_claim_id: gene_claim.id,
      ).first_or_create
    end

    def create_drug_claim(name, primary_name, nomenclature)
      DataModel::DrugClaim.where(
        name: name,
        primary_name: primary_name,
        nomenclature: nomenclature,
        source_id: @source.id,
      ).first_or_create
    end

    def create_interaction_claim(gene_claim, drug_claim)
      DataModel::InteractionClaim.where(
        gene_claim_id: gene_claim.id,
        drug_claim_id: drug_claim.id,
        source_id: @source.id
      ).first_or_create
    end

    def create_interaction_claim_publication(interaction_claim, pmid)
      publication = DataModel::Publication.where(
        pmid: pmid
      ).first_or_create
      interaction_claim.publications << publication unless interaction_claim.publications.include? publication
    end

    def create_interaction_claim_attribute(interaction_claim, name, value)
      DataModel::InteractionClaimAttribute.where(
        name: name,
        value: value,
        interaction_claim_id: interaction_claim.id
      ).first_or_create
    end
  end
end
