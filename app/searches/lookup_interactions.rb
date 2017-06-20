class LookupInteractions
  extend FilterHelper

  def self.find(params)
    #find identifier results for given search terms. end up with
    #an object of type "InteractionSearchResult" for each
    #search result
    if params[:search_mode] == 'genes'
      interaction_results = LookupGenes.find(
        params[:gene_names],
        :for_search,
        InteractionSearchResult
      )
    else
      interaction_results = LookupDrugs.find(
        params[:drug_names],
        :for_search,
        InteractionSearchResult
      )
    end

    #get a filter chain encompassing all the given filters from the search form
    filter = create_filter_from_params(params)
    # actually filter down the results we want
    filter_results(interaction_results, filter)

    # return filtered set of interactions
    interaction_results
  end

  private
  #for each interaction in each result, remove it from the list of interactions
  #for that result if it doesn't meet the filter
  def self.filter_results(interaction_results, filter)
    interaction_results.each do |result|
      # underlying select operation in filter_interactions from interaction_search_result.rb
      result.filter_interactions do |interaction|
        filter.include?(interaction.id)
      end
    end
  end

  def self.create_filter_from_params(params)
    #TODO this is currently a hack since we're only supporting one drug type on our form
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
    fda_approved_drug: :include_fda_approved_drug,
    immunotherapy: :include_immunotherapy,
    anti_neoplastic: :include_antineoplastic,
    clinically_actionable: :include_clinically_actionable,
    drug_resistance: :include_drug_resistance,
    druggable_genome: :include_druggable_genome
  }
end
