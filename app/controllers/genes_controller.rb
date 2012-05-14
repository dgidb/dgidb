class GenesController < ApplicationController
  def show
  @title = params[:name]
  @genes = Gene.where(name: params[:name])
  end
end
