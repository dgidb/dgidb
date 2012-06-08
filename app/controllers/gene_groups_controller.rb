class GeneGroupsController < ApplicationController
  def show
    @title = params[:name]
    @gene_group = DataModel::GeneGroup.where(name: params[:name]).first
  end

  def names
    cache_key = "gene_group_names"
    if Rails.cache.exist?(cache_key)
      @names = Rails.cache.fetch(cache_key)
    else
      @names = DataModel::GeneGroup.pluck(:name)
      Rails.cache.write(cache_key, @names, expires_in: 30.minutes)
    end
    respond_to do |format|
      format.json {render json:  @names.to_json}
    end
  end

  def family
    @gene_groups = LookupFamilies.find_gene_groups_for_families(params[:name])
    @title = "Gene Groups in the #{params[:name]} family"
    @family_name = params[:name]
  end

  def families
    @family_names = LookupFamilies.get_uniq_family_names
    @title = "Gene Group Families"
  end

  def family_search_results
    gene_names = params[:genes].split("\n").collect(&:strip)
    unless params[:geneFile].nil?
      gene_names.concat(params[:geneFile].read.split("\n")).collect(&:strip)
    end
    gene_names.delete_if(&:empty?)
    params[:gene_names] = gene_names

    search_results = LookupGenes.find(params, :for_gene_families)
    @search_results = GeneFamilySearchResultsPresenter.new(search_results, params)
  end

end
