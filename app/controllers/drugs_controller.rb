class DrugsController < ApplicationController
  def show
    @title = params[:name]
    @drugs = DataModel::Drug.where(name: params[:name])
  end
end
