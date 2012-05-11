class DrugsController < ApplicationController
  def show
    @drugs = Drug.where(name: params[:name])
  end
end
