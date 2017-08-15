class LookupInteractions
  extend FilterHelper

  def self.find(params)
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

    filter = create_filter_from_params(params)
    filter_results(interaction_results, filter)
    interaction_results
  end

  def self.logical_find(term, params, matches=[], run=1)
    if run == 1
      if params[:search_mode] == 'genes'
        interaction_results = LookupGenes.find(
          params[:gene_names],
          :for_search,
          InteractionSearchResult
        )
      elsif params[:search_mode] == 'drugs'
        interaction_results = LookupDrugs.find(
          params[:drug_names],
          :for_search,
          InteractionSearchResult
        )
      else
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
        if result.interactions.any? && params[:search_mode] == 'mixed'
          params[:search_mode] = result.type
        end
        result.filter_interactions do |interaction|
          dg_res[0] << interaction.gene_id
          dg_res[1] << interaction.drug_id
        end
      end
      dg_res[0] = dg_res[0].uniq
      dg_res[1] = dg_res[1].uniq

      if params[:search_mode] == 'genes'
        dg_res[2] << dg_res[0][0]
      elsif params[:search_mode] == 'drugs'
        dg_res[3] << dg_res[1][0]
      end
      dg_res
    else
      if params[:search_mode] == 'genes'
        interaction_results = LookupGenes.find(
          params[:gene_names],
          :for_search,
          InteractionSearchResult
        )
      elsif params[:search_mode] == 'drugs'
        interaction_results = LookupDrugs.find(
          params[:drug_names],
          :for_search,
          InteractionSearchResult
        )
      else
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
          if result.interactions.any? && params[:search_mode] == 'mixed'
            params[:search_mode] = result.type
            if params[:search_mode] == 'genes'
              params.delete(:drugs)
              params.delete(:drug_names)
              interaction_results.delete_at(1)
            elsif params[:search_mode] == 'drugs'
              params.delete(:genes)
              params.delete(:gene_names)
              interaction_results.delete_at(0)
            end
          end
        end
      end

      filter = create_filter_from_params(params)
      filter_results(interaction_results, filter, matches)
      interaction_results
    end
  end

  private
  def self.filter_results(interaction_results, filter, matches = [])
    interaction_results.each do |result|
      result.filter_interactions do |interaction|
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
