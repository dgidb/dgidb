class InteractionsController < ApplicationController
  def show
    interaction = DataModel::Interaction.find(params[:id])
    @interaction = InteractionPresenter.new(interaction)
    @title = @interaction.display_name
  end
end
