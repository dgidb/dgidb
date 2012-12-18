class DrugsController < ApplicationController
  caches_page :show

  def show
    @title = params[:name]
    @drug = DataModel::Drug.where(name: params[:name]).first
  end

  def related_drugs
    @drugs = LookupRelatedDrugs.find(params[:name])
  end
end
