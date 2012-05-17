class InteractionsController < ApplicationController
  def show
    @interaction = DataModel::Interaction.find(params[:id])
    @drug = @interaction.drug
    @gene = @interaction.gene
  end
  def interaction_search_results
    search_results = LookupInteractions.find_groups_and_interactions(["FLT3", "SKIPPYPEANUTBUTTER", "STK1"]) #TODO: pass in gene_names from the form params hash wheeee
    @search_results = SearchResultsPresenter.new(search_results)
  end
end
