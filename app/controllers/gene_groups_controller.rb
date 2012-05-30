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
end
