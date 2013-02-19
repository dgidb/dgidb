class InteractionClaimsController < ApplicationController
  caches_page :show
  def show
    @interaction = DataModel::InteractionClaim.for_show.find(params[:id])
    @drug = @interaction.drug_claim
    @gene = @interaction.gene_claim
  end

  def interaction_search_results
    @search_interactions_active = 'active'
    start_time = Time.now
    combine_input_genes(params)
    validate_search_request(params)

    search_results = LookupInteractions.find(params)

    respond_to do |format|
      format.html do
        @search_results = InteractionSearchResultsPresenter.new(search_results, start_time)
        if params[:outputFormat] == 'tsv'
          generate_tsv_headers('interactions_export.tsv')
          render 'interactions_export.tsv', content_type: 'text/tsv', layout: false
        end
      end
      format.json { @search_results = InteractionSearchResultsApiPresenter.new(search_results) }
    end
  end

  private
  def validate_search_request(params)
    bad_request('You must enter at least one gene name to search!') if params[:gene_names].size == 0
    #TODO: this is a hack to allow for api users to specify no filters to get all inclusive... need a real way of doing this
    params[:sources] = DataModel::Source.source_names_with_interactions unless params[:sources]
    params[:gene_categories] = DataModel::GeneClaimCategory.all_category_names unless params[:gene_categories]
    params[:interaction_types] = DataModel::InteractionClaimType.all_type_names unless params[:interaction_types]
  end

end
