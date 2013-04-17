class DrugClaimsController < ApplicationController
  def show
    @drug_claim = DrugClaimPresenter.new DataModel::DrugClaim.for_show
      .where(name: params[:name])
      .where('sources.source_db_name' => params[:source_db_name])
      .first
  end
end
