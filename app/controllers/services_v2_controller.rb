class ServicesV2Controller < ApplicationController
  include ApiAnalytics

  def genes
    genes = DataModel::Gene.eager_load(:gene_aliases).page(params[:page]).per(params[:count])
    render json: PaginatedCollectionPresenter.new(
      genes,
      request,
      GenePresenter,
      PaginationPresenter
    )
  end

  def gene_details
    gene_details = GeneDetailPresenter.new(DataModel::Gene.find_by!(entrez_id: params[:entrez_id])).as_json
    render json: gene_details
  end

  def drugs
    drugs = DataModel::Drug.eager_load(:drug_aliases).page(params[:page]).per(params[:count])
    render json: PaginatedCollectionPresenter.new(
      drugs,
      request,
      DrugPresenter,
      PaginationPresenter
    )
  end

  def drug_details
    drug_details = DrugDetailPresenter.new(DataModel::Drug.find_by!(chembl_id: params[:chembl_id])).as_json
    render json: drug_details
  end

  def render_all_interactions
    interactions = DataModel::Interaction.eager_load(:gene, :drug, :publications, :interaction_types, :sources)
      .page(params[:page])
      .per(params[:count])
    render json: PaginatedCollectionPresenter.new(
      interactions,
      request,
      InteractionPresenter,
      PaginationPresenter
    )
  end

  def interaction_details
    interaction_details = InteractionDetailPresenter.new(DataModel::Interaction.find_by!(id: params[:id])).as_json
    render json: interaction_details
  end

  def gene_categories
    render_format DataModel::GeneClaimCategory.all_category_names
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
    elsif params.key?(:genes)
      combine_input_genes(params)
    elsif params.keys.sort == ['action', 'controller', 'format'] or
          params.keys.sort == ['action', 'controller'] or
          (params.key?(:count) and params.key?(:page))
      render_all_interactions()
      return
    end
    validate_interaction_request(params)
    combine_entries(params)
    search_results = LookupInteractions.find(params)
    @search_results = InteractionSearchResultsApiV2Presenter.new(search_results)
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
    [:interaction_sources, :gene_categories, :interaction_types, :source_trust_levels]
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
