class GenesController < ApplicationController

  def show
    gene = DataModel::Gene.for_show.where('lower(genes.name) = ?', params[:name].downcase)
      .first || not_found("#{params[:name]} wasn't found!")
    @gene = GenePresenter.new(gene)
    @title = @gene.display_name
  end

  def names
    @names = DataModel::Gene.all_gene_names
    respond_to do |format|
      format.json {render json:  @names.to_json}
    end
  end

  def druggable_gene_category
    sources = if params[:sources]
                  params[:sources].split(',').flatten
                else
                  DataModel::Source.source_names_with_category_information
                end
    genes = LookupCategories.find_genes_for_category_and_sources(params[:name], sources)
    @genes = DruggableGeneCategoryPresenter.new(genes, sources, view_context)
    @title = params[:name]
    @druggable_gene_categories_active = 'active'
    @category_name = params[:name]
  end

  def druggable_gene_categories
    @sources = DataModel::Source.source_names_with_category_information
    @title = 'Druggable Gene Categories'
    @druggable_gene_categories_active = 'active'
  end

  def categories_search_results
    @view_context = view_context
    @search_categories_active = 'active'
    start_time = Time.now
    validate_search_request(params)
    combine_input_genes(params)

    search_results = LookupCategories.find(params)
    @search_results = GeneCategorySearchResultsPresenter.new(search_results, params, start_time, view_context)
  end

  private
  def validate_search_request(params)
    bad_request("Please enter at least one gene to search!") if params[:genes].blank?
    params[:gene_categories] = DataModel::GeneClaimCategory.all_category_names unless params[:gene_categories]
    params[:sources] = DataModel::Source.potentially_druggable_source_names unless params[:sources]
    params[:source_trust_levels] = DataModel::SourceTrustLevel.all_trust_levels unless params[:source_trust_levels]

  end

end
