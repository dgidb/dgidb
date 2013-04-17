class GeneClaimsController < ApplicationController
  def show
    name_param = params[:name]
    source_db_name_param = params[:source_db_name]
    @gene_claim = GeneClaimPresenter.new DataModel::GeneClaim.for_show
      .where(name: name_param)
      .where('sources.source_db_name' => source_db_name_param)
      .first
  end
end
