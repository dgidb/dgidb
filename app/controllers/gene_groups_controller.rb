class GeneGroupsController < ApplicationController
  def show
    @title = params[:name]
    @gene_groups = GeneGroup.where(name: params[:name])
  end

  respond_to :json
  def names
    @names = GeneGroup.pluck(:name)
    respond_with(@names)
  end
end
