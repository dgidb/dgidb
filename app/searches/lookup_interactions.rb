class LookupInteractions
  extend FilterHelper

  def self.find(params)
    #get a filter chain encompassing all the given filters from the search form
    filter = create_filter_from_params(params)

    #find identifier results for given search terms. end up with
    #an object of type "InteractionSearchResult" for each
    #search result
    if params[:search_mode] == 'genes'
      LookupGenes.find(
        params[:gene_names],
        :for_search,
        InteractionSearchResult,
        filter
      )
    else
      LookupDrugs.find(
        params[:drug_names],
        :for_search,
        InteractionSearchResult,
        filter
      )
    end
  end

  private
  def self.create_filter_from_params(params)
    #TODO this is currently a hack since we're only supporting one drug type on our form
    #This needs to stick around for v1 of the API to still work
    if params[:limit_drugs] == 'true' || params[:drug_types]
      params[:drug_types] ||= ['antineoplastic']
    end

    construct_filter(PARAM_KEY_TO_FILTER_NAME_MAP, params)
  end

  PARAM_KEY_TO_FILTER_NAME_MAP = {
    drug_types: :include_drug_claim_type,
    interaction_sources: :include_source_db_name,
    gene_categories: :include_gene_claim_category_interaction,
    interaction_types:  :include_interaction_claim_type,
    source_trust_levels: :include_source_trust_level,
    approved_drug: :include_approved_drug,
    immunotherapy: :include_immunotherapy,
    anti_neoplastic: :include_anti_neoplastic,
    clinically_actionable: :include_clinically_actionable,
    drug_resistance: :include_drug_resistance,
    druggable_genome: :include_druggable_genome
  }
end
