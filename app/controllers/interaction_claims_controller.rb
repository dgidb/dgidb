class InteractionClaimsController < ApplicationController
  caches_page :show
  def show
    @interaction = InteractionClaimPresenter.new(
      DataModel::InteractionClaim.for_show.find(params[:id]))
  end

  def interaction_search_results
    @search_interactions_active = 'active'
    start_time = Time.now
    combine_input_genes(params)
    validate_interaction_request(params)

    search_results = LookupInteractions.find(params)
    @search_results = InteractionSearchResultsPresenter.new(search_results, start_time)
  end

  private
  def validate_interaction_request(params)
    bad_request('You must enter at least one gene name to search!') if params[:gene_names].size == 0
    params[:interaction_sources] = DataModel::Source.source_names_with_interactions unless params[:interaction_sources]
    params[:gene_categories] = DataModel::GeneClaimCategory.all_category_names unless params[:gene_categories]
    params[:interaction_types] = DataModel::InteractionClaimType.all_type_names unless params[:interaction_types]
    #params[:drug_types] = DataModel::DrugClaimType.all_type_names unless params[:drug_types]
    params[:source_trust_levels] = DataModel::SourceTrustLevel.all_trust_levels unless params[:source_trust_levels]
  end
end
