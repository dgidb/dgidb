class ServicesController < ApplicationController

  def gene_id_mapping
    validate_gene_id_mapping_request(params)
    gene_claim = DataModel::GeneClaim.for_gene_id_mapping
      .where(name: params[:gene_id]).first ||
      not_found("A gene with the ID #{params[:gene_id]} was not found!")

    @result = GeneIdMappingPresenter.new(gene_claim, params[:gene_id])
  end

  private
  def validate_gene_id_mapping_request(params)
    bad_request('Please specify a gene id as gene_id!') if params[:gene_id].blank?
  end

end
