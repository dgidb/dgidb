class GenesController < ApplicationController

  caches_page :show, :druggable_gene_category, :druggable_gene_categories

  def show
    @gene_group = DataModel::Gene.where(name: params[:name]).first
    @gene_group_presenter = GenePresenter.new(@gene_group)
    @title = @gene_group_presenter.display_name
  end

  def names
    cache_key = "gene_group_names"
    if Rails.cache.exist?(cache_key)
      @names = Rails.cache.fetch(cache_key)
    else
      @names = DataModel::Gene.pluck(:name)
      Rails.cache.write(cache_key, @names, expires_in: 30.minutes)
    end
    respond_to do |format|
      format.json {render json:  @names.to_json}
    end
  end

  def druggable_gene_category
    genes = LookupCategories.find_genes_for_categories(params[:name])
    @genes = DruggableGeneCategoryPresenter.new(genes[params[:name]])
    @title = "Genes in the #{params[:name]} category"
    @druggable_gene_categories_active = 'active'
    @category_name = params[:name]
  end

  def druggable_gene_categories
    @categories = LookupCategories.get_uniq_category_names_with_counts
    @title = 'Druggable Gene Categories'
    @druggable_gene_categories_active = 'active'
  end

  def categories_search_results
    @search_categories_active = 'active'
    start_time = Time.now
    combine_input_genes(params)
    validate_search_request(params)

    search_results = LookupGenes.find(params, :for_gene_categories)
    @search_results = GeneCategorySearchResultsPresenter.new(search_results, params, start_time)
    if params[:outputFormat] == 'tsv'
      generate_tsv_headers('gene_categories_export.tsv')
      render 'gene_categories_export.tsv', content_type: 'text/tsv', layout: false
    end
  end

  private
  def validate_search_request(params)
    bad_request("Please enter at least one gene category to search!") unless params[:gene_names].size > 0
  end

end
