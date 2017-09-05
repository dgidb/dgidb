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

  def gene_categories_for_sources
    render_format LookupCategories.get_category_names_with_counts_in_sources(
      params[:sources].split(',')
    )
  end

  def genes_in_category
    category_name = params[:category].upcase
    DataModel::GeneClaimCategory.where(name: category_name).any? ||
      not_found("Sorry, no category with the name #{category_name} was found.")

    render_format LookupCategories.gene_names_in_category(category_name)
  end

  def related_genes
    combine_input_genes(params)
    @genes = LookupRelatedGenes.find(params[:gene_names])
  end

  def interactions
    if params.key?(:drugs)
      combine_input_drugs(params)
    else
      combine_input_genes(params)
    end
    validate_interaction_request(params)
    combine_entries(params)
    search_results = LookupInteractions.find(params)
    @search_results = InteractionSearchResultsApiV1Presenter.new(search_results)
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

  def render_format(obj)
    respond_to do |format|
      format.json { render json: obj.to_json }
      format.xml  { render xml: obj.to_xml }
      format.all  { render json: obj.to_json }
    end
  end

end
