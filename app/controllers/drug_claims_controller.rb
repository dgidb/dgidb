class DrugClaimsController < ApplicationController
  caches_page :show
  def show
    @drug_claim = DrugClaimPresenter.new DataModel::DrugClaim.for_show.where(name: params[:name]).first
  end
end
