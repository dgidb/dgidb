class GenesController < ApplicationController
  def show
    @title = params[:name]
    @genes = DataModel::Gene.where(name: params[:name])
  end

  def family_search_results
  end
end
