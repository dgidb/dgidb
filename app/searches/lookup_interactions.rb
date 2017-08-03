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

  def self.logical_find(term, params, matches=[], run=1)
    #byebug
    if run == 1
      if params[:search_mode] == 'genes'
        interaction_results = LookupGenes.find(
          params[:gene_names],
          :for_search,
          InteractionSearchResult
        )
      #elsif regex "String[type]" => type == 'drugs' ^
      elsif params[:search_mode] == 'drugs'
        interaction_results = LookupDrugs.find(
          params[:drug_names],
          :for_search,
          InteractionSearchResult
        )
      else
        #byebug
        interaction_results = LookupGenes.find(
          params[:gene_names],
          :for_search,
          InteractionSearchResult
        )
        interaction_results.concat(
          LookupDrugs.find(
            params[:drug_names],
            :for_search,
            InteractionSearchResult
          )
        ).uniq
      end

      filter = create_filter_from_params(params)
      filter_results(interaction_results, filter)

      dg_res = [[], [], [], []]
      interaction_results.each do |result|
        if result.interactions.any?
          if result == interaction_results[0]
            params[:search_mode] == 'genes'
          elsif result == interaction_results[1]
            params[:search_mode] == 'drugs'
          end
        end
        result.filter_interactions do |interaction|
          dg_res[0] << interaction.gene_id
          dg_res[1] << interaction.drug_id
        end
      end
      dg_res[0] = dg_res[0].uniq
      dg_res[1] = dg_res[1].uniq

      if params[:search_mode] == 'genes'
        dg_res[2] = dg_res[0][0]
      elsif params[:search_mode] == 'drugs'
        dg_res[3] = dg_res[1][0]
      else
        if dg_res[0].length != dg_res[1].length
          if dg_res[0].length < dg_res[1].length
            dg_res[2] << dg_res[0][0]
            params[:search_mode] = 'genes'
            params.delete(:drugs)
            params.delete(:drug_names)
          else
            dg_res[3] << dg_res[1][0]
            params[:search_mode] = 'drugs'
            params.delete(:genes)
            params.delete(:gene_names)
          end
        end
      end
      dg_res
    else
      if params[:search_mode] == 'genes'
        interaction_results = LookupGenes.find(
          params[:gene_names],
          :for_search,
          InteractionSearchResult
        )
      #elsif regex "String[type]" => type == 'drugs' ^
      elsif params[:search_mode] == 'drugs'
        interaction_results = LookupDrugs.find(
          params[:drug_names],
          :for_search,
          InteractionSearchResult
        )
      #else
        #search genes, drugs, then \/
        #ir = genes .concat drugs .uniq
      else
        #byebug
        interaction_results = LookupGenes.find(
          params[:gene_names],
          :for_search,
          InteractionSearchResult
        )
        interaction_results.concat(
          LookupDrugs.find(
            params[:drug_names],
            :for_search,
            InteractionSearchResult
          )
        ).uniq

        interaction_results.each do |result|
          if result.interactions.any?
            params[:search_mode] = result.type
          end
        end

        if params[:search_mode] == 'genes'
          params.delete(:drugs)
          params.delete(:drug_names)
          interaction_results.delete_at(1)
        elsif params[:search_mode] == 'drugs'
          params.delete(:genes)
          params.delete(:gene_names)
          interaction_results.delete_at(0)
        elsif interaction_results[0].inspect.length > interaction_results[1].inspect.length
          params[:search_mode] = 'genes'
          params.delete(:drugs)
          params.delete(:drug_names)
          interaction_results.delete_at(1)
        else
          params[:search_mode] = 'drugs'
          params.delete(:genes)
          params.delete(:gene_names)
          interaction_results.delete_at(0)
        end
      end

      filter = create_filter_from_params(params)
      filter_results(interaction_results, filter, matches)
      interaction_results
    end
  end

  private
  #for each interaction in each result, remove it from the list of interactions
  #for that result if it doesn't meet the filter
  def self.filter_results(interaction_results, filter, matches = [])
    interaction_results.each do |result|
      result.filter_interactions do |interaction|
        #byebug
        filter.include?(interaction, matches)
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
    anti_neoplastic: :include_anti_neoplastic,
    clinically_actionable: :include_clinically_actionable,
    drug_resistance: :include_drug_resistance,
    druggable_genome: :include_druggable_genome
  }
end
