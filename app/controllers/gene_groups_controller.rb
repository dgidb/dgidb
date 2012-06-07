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
  end

  def families
    @family_names = LookupFamilies.get_uniq_family_names
    @title = "Gene Group Families"
  end

end
