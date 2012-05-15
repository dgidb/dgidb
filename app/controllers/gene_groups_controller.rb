class GeneGroupsController < ApplicationController
  def show
  @title = params[:name]
  @gene_groups = GeneGroup.where(name: params[:name])
  end
end
