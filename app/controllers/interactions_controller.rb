class InteractionsController < ApplicationController
  def show
    @interaction = DataModel::Interaction.find(params[:id])
    @drug = @interaction.drug
    @gene = @interaction.gene
  end

  def interaction_search_results
    start_time = Time.now
    gene_names = params[:genes].split("\n")
    unless params[:geneFile].nil?
      gene_names.concat(params[:geneFile].read.split("\n"))
    end
    gene_names.delete_if(&:empty?)
    params[:gene_names] = gene_names.map{ |name| name.strip.upcase }

    validate_search_request(params)

    search_results = LookupGenes.find(params)
    @search_results = InteractionSearchResultsPresenter.new(search_results, params, start_time)
    if params[:outputFormat] == 'tsv'
      generate_tsv_headers('interactions_export.tsv')
      render 'interactions_export.tsv', content_type: 'text/tsv', layout: false
    end
  end

  private
  def validate_search_request(params)
    bad_request("You must enter at least one gene name to search!") if params[:gene_names].size == 0
    bad_request("You must upload a plain text formated file") if params[:geneFile] && !validate_file_format('text/plain;', params[:geneFile].tempfile.path)
  end

end
