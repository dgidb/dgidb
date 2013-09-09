class InteractionClaimsController < ApplicationController
  caches_page :show
  def show
    @interaction = InteractionClaimPresenter.new(
      DataModel::InteractionClaim.for_show.find(params[:id]))
  end

  def interaction_search_results
    @search_interactions_active = 'active'
    combine_input_genes(params)
    perform_interaction_search
  end

  def interactions_for_related_genes
    @related_source_gene = params[:genes]
    combine_input_genes(params)
    related_genes = LookupRelatedGenes.find(params[:gene_names])
    if related_genes.empty?
      not_found("Sorry, we don't have any genes related to #{@related_source_gene}")
    end
    params[:gene_names] = related_genes.flat_map(&:gene_gene_interaction_claims)
      .map { |ic| ic.interacting_gene.name }
    perform_interaction_search
    render :interaction_search_results
  end

  private
  def perform_interaction_search
    start_time = Time.now
    validate_interaction_request(params)
    search_results = LookupInteractions.find(params)
    @search_results = InteractionSearchResultsPresenter.new(search_results, start_time)
  end

end
