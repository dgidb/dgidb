class GenesController < ApplicationController
  caches_page :show
  def show
    @title = params[:name]
    name_param = params[:name]
    source_db_name_param = params[:source_db_name]
    @genes = DataModel::Gene.joins{citation}.where{name.eq(name_param) & citation.source_db_name.like(source_db_name_param)}
  end
end
