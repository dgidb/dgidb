class DrugsController < ApplicationController

  def show
    @title = params[:name]
    @drug = DataModel::Drug.where(name: params[:name]).first || not_found("No drug matches name #{params[:name]}")
  end

  def related_drugs
    @drugs = LookupRelatedDrugs.find(params[:name])
  end
end
