class GeneClaimsController < ApplicationController
  caches_page :show
  def show
    @title = params[:name]
    name_param = params[:name]
    source_db_name_param = params[:source_db_name]
    @genes = DataModel::GeneClaim.joins(:source)
      .where(name: name_param)
      .where('sources.source_db_name' => source_db_name_param)
  end
end
