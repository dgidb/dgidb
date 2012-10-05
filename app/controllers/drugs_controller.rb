class DrugsController < ApplicationController
  caches_page :show
  def show
    @title = params[:name]
    @drugs = DataModel::Drug.where(name: params[:name])
  end
end
