class InteractionClaimsController < ApplicationController
  def show
    @interaction = InteractionClaimPresenter.new(
      DataModel::InteractionClaim.for_show.find(params[:id]))
  end

  def interaction_search_results
    if !params[:name].nil?
      params[:search_mode] = 'drugs'
      params[:identifiers] = params[:name]
      params[:gene_categories] = DataModel::GeneClaimCategory.all_category_names unless params[:gene_categories]
      params[:sources] = DataModel::Source.potentially_druggable_source_names unless params[:sources]
      params[:source_trust_levels] = DataModel::SourceTrustLevel.all_trust_levels unless params[:source_trust_levels]
    end
    @search_interactions_active = 'active'
    @search_mode = params[:search_mode]
    if @search_mode == 'drugs'
      params[:drugs] = params[:identifiers]
      combine_input_drugs(params)
    elsif @search_mode == 'genes'
      params[:genes] = params[:identifiers]
      combine_input_genes(params)
    else
      if params[:genes]
        combine_input_genes(params)
      elsif params[:drugs]
        combine_input_drugs(params)
      end
    end
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
    @search_results = InteractionSearchResultsPresenter.new(search_results, start_time, view_context)
  end

end
