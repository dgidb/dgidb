class ServicesV1Controller < ApplicationController

  def gene_categories
    render_format DataModel::GeneClaimCategory.all_category_names
  end

  def drug_types
   render_format DataModel::DrugClaimType.all_type_names
  end

  def interaction_types
    render_format DataModel::InteractionClaimType.all_type_names
  end

  def interaction_sources
    render_format DataModel::Source.source_names_with_interactions
  end

  def source_trust_levels
    render_format DataModel::SourceTrustLevel.all_trust_levels
  end

  def interactions
    combine_input_genes(params)
    validate_interaction_request(params)
    combine_entries(params)
    search_results = LookupInteractions.find(params)
    @search_results = InteractionSearchResultsApiPresenter.new(search_results)
  end

  def gene_id_mapping
    validate_gene_id_mapping_request(params)
    gene_claim = DataModel::GeneClaim.for_gene_id_mapping
      .where(name: params[:gene_id]).first ||
      not_found("A gene with the ID #{params[:gene_id]} was not found!")

    @result = GeneIdMappingPresenter.new(gene_claim, params[:gene_id])
  end

  private
  def validate_gene_id_mapping_request(params)
    bad_request('Please specify a gene id as gene_id!') if params[:gene_id].blank?
  end

  def combine_entries(params)
    [:interaction_sources, :gene_categories, :interaction_types, :drug_types, :source_trust_levels]
    .reject{|arg| params[arg].class == Array}.each do |arg|
      params[arg] = params[arg].split(',').map(&:strip) if params[arg]
    end
  end

  def validate_interaction_request(params)
    bad_request('You must enter at least one gene name to search!') if params[:gene_names].size == 0
    params[:interaction_sources] = DataModel::Source.source_names_with_interactions unless params[:interaction_sources]
    params[:gene_categories] = DataModel::GeneClaimCategory.all_category_names unless params[:gene_categories]
    params[:interaction_types] = DataModel::InteractionClaimType.all_type_names unless params[:interaction_types]
    params[:drug_types] = DataModel::DrugClaimType.all_type_names unless params[:drug_types]
    params[:source_trust_levels] = DataModel::SourceTrustLevel.all_trust_levels unless params[:source_trust_levels]
  end

  def render_format(obj)
    respond_to do |format|
      format.json { render json: obj.to_json }
      format.xml  { render xml: obj.to_xml }
      format.all  { render json: obj.to_json }
    end
  end

end
