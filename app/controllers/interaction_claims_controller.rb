class InteractionClaimsController < ApplicationController
  caches_page :show
  def show
    @interaction = DataModel::InteractionClaim.find(params[:id])
    @drug = @interaction.drug_claim
    @gene = @interaction.gene_claim
    @title = "#{@drug.name} acting on #{@gene.name}"
  end

  def interaction_search_results
    @search_interactions_active = 'active'
    start_time = Time.now
    combine_input_genes(params)
    validate_search_request(params)

    search_results = LookupInteractions.find(params)
    @search_results = InteractionSearchResultsPresenter.new(search_results, start_time)
    if params[:outputFormat] == 'tsv'
      generate_tsv_headers('interactions_export.tsv')
      render 'interactions_export.tsv', content_type: 'text/tsv', layout: false
    end
  end

  private
  def validate_search_request(params)
    bad_request('You must enter at least one gene name to search!') if params[:gene_names].size == 0
    bad_request('You must select at least one source to search!') unless params[:sources]
    bad_request('You must select at least one gene category to search!') unless params[:gene_categories]
    bad_request('You must select at least one interaction type to search!') unless params[:interaction_types]
  end

end
