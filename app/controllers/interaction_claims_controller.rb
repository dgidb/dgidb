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

end
