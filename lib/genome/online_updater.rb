module Genome
  class OnlineUpdater
    def create_gene_claim(gene_name, nomenclature)
      DataModel::GeneClaim.where(
        name: gene_name.strip(),
        nomenclature: nomenclature.strip(),
        source_id: @source.id
      ).first_or_create
    end

    def create_gene_claim_alias(gene_claim, synonym, nomenclature)
      DataModel::GeneClaimAlias.where(
        alias: synonym.to_s.strip(),
        nomenclature: nomenclature.strip(),
        gene_claim_id: gene_claim.id,
      ).first_or_create
    end

    def create_gene_claim_attribute(gene_claim, name, value)
      DataModel::GeneClaimAttribute.where(
        name: name.strip(),
        value: value.strip(),
        gene_claim_id: gene_claim.id,
      ).first_or_create
    end

    def create_drug_claim(name, primary_name, nomenclature)
      DataModel::DrugClaim.where(
        name: name.strip(),
        primary_name: primary_name.strip(),
        nomenclature: nomenclature.strip(),
        source_id: @source.id,
      ).first_or_create
    end

    def create_drug_claim_alias(drug_claim, synonym, nomenclature)
      cleaned = synonym.gsub(/[^\w_]+/,'').upcase
      return nil unless DataModel::DrugAliasBlacklist.find_by(alias: cleaned).nil?
      DataModel::DrugClaimAlias.where(
        alias: synonym.strip(),
        nomenclature: nomenclature.strip(),
        drug_claim_id: drug_claim.id,
      ).first_or_create
    end

    def create_drug_claim_attribute(drug_claim, name, value)
      DataModel::DrugClaimAttribute.where(
        name: name.strip(),
        value: value.strip(),
        drug_claim_id: drug_claim.id
      ).first_or_create
    end

    def create_interaction_claim(gene_claim, drug_claim)
      DataModel::InteractionClaim.where(
        gene_claim_id: gene_claim.id,
        drug_claim_id: drug_claim.id,
        source_id: @source.id
      ).first_or_create
    end

    def create_interaction_claim_type(interaction_claim, type)
      claim_type = DataModel::InteractionClaimType.where(
        type: type.strip()
      ).first_or_create
      interaction_claim.interaction_claim_types << claim_type unless interaction_claim.interaction_claim_types.include? claim_type
    end

    def create_interaction_claim_publication(interaction_claim, pmid)
      publication = DataModel::Publication.where(
        pmid: pmid
      ).first_or_create
      if publication.citation.nil?
        publication.citation = PMID.get_citation_from_pubmed_id(pmid)
        publication.save
        sleep(1)
      end
      interaction_claim.publications << publication unless interaction_claim.publications.include? publication
    end

    def create_interaction_claim_publication_by_pmcid(interaction_claim, pmcid)
      uri = URI.parse("https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?ids=#{pmcid}&format=json&tool=DGIdb&email=help@dgidb.org")
      res = Net::HTTP.get_response(uri)
      raise StandardError.new(res.body) unless res.code == '200'
      pmid = JSON.parse(res.body)['records'][0]['pmid']
      if !pmid.nil?
        create_interaction_claim_publication(interaction_claim, pmid)
      end
    end

    def create_interaction_claim_attribute(interaction_claim, name, value)
      DataModel::InteractionClaimAttribute.where(
        name: name.to_s.strip(),
        value: value.strip(),
        interaction_claim_id: interaction_claim.id
      ).first_or_create
    end

    def create_interaction_claim_link(interaction_claim, link_text, link_url)
      DataModel::InteractionClaimLink.where(
        interaction_claim_id: interaction_claim.id,
        link_text: link_text,
        link_url: link_url,
      ).first_or_create
    end
  end
end
