class DrugClaimsController < ApplicationController
  caches_page :show
  def show
    @title = params[:name]
    @drugs = DataModel::DrugClaim.for_show.where(name: params[:name])
  end
end
