class GeneClaimsController < ApplicationController
  def show
    @gene_claim = GeneClaimPresenter.new DataModel::GeneClaim.for_show
      .where(name: params[:name].upcase)
      .where('lower(sources.source_db_name) = ?', params[:source_db_name].downcase)
      .first || not_found("No gene claim from #{params[:source_db_name]} with name #{params[:name]} found!")
  end
end
