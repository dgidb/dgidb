class DrugsController < ApplicationController
  def show
    @title = params[:name]
    @drugs = Drug.where(name: params[:name])
  end
end
