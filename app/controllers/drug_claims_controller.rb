class DrugClaimsController < ApplicationController
  def show
    result = DataModel::DrugClaim.for_show
      .where(name: params[:name].upcase)
      .where('sources.source_db_name' => params[:source_db_name])
      .first || not_found("No drug claim from #{params[:source_db_name]} with name #{params[:name]} found!")

      @drug_claim = DrugClaimPresenter.new(result)
  end
end
