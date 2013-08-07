class GeneClaimsController < ApplicationController
  def show
    @gene_claim = GeneClaimPresenter.new DataModel::GeneClaim.for_show
      .where(name: params[:name].upcase)
      .where('sources.source_db_name' => params[:source_db_name])
      .first
  end
end
