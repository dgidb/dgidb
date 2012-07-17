class DrugGroupsController < ApplicationController
  def show
    @title = params[:name]
    @drug_group = DataModel::DrugGroup.where(name: params[:name]).first
  end
end
