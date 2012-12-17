class DrugsController < ApplicationController
  caches_page :show

  def show
    @title = params[:name]
    @drug_group = DataModel::Drug.where(name: params[:name]).first
  end

  def related_drug_groups
    @drugs = LookupRelatedDrugs.find(params[:name])
  end
end
