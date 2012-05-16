class InteractionsController < ApplicationController
  def show
    @interaction = Interaction.find(params[:id])
    @drug = @interaction.drug
    @gene = @interaction.gene
  end
  def test
  #TODO: write something here
  end
end
