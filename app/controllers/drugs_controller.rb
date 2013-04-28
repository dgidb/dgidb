class DrugsController < ApplicationController

  def show
    @title = "DGIdb - #{params[:name]} drug record"
    @drug = DataModel::Drug.where(name: params[:name]).first || not_found("No drug matches name #{params[:name]}")
  end

  def related_drugs
    @drugs = LookupRelatedDrugs.find(params[:name])
  end
end
