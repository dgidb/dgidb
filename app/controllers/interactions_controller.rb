class InteractionsController < ApplicationController
  def show
    @interaction = DataModel::Interaction.find(params[:id])
    @drug = @interaction.drug
    @gene = @interaction.gene
  end
  def interaction_search_results
    @params = params
    @geneNames = params[:genes].split("\n").collect(&:strip)
    unless params[:geneFile].nil?
      @geneNames.concat(params[:geneFile].read.split("\n")).collect(&:strip)
    end
    @geneNames.delete_if(&:empty?)
    @geneGroups = DataModel::GeneGroup.where(name: @geneNames)

    search_results = LookupInteractions.find_groups_and_interactions(@geneNames) #TODO: pass in gene_names from the form params hash wheeee
    @search_results = SearchResultsPresenter.new(search_results)
  end
end
