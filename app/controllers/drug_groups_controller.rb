class DrugGroupsController < ApplicationController
  def show
    @title = params[:name]
    @drug_group = DataModel::DrugGroup.where(name: params[:name]).first
  end

  def related_drug_groups
    @drugs = LookupRelatedDrugs.find(params[:name])
  end
end
