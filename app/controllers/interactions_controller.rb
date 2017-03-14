class InteractionsController < ApplicationController
  def show
  	# this is all basically just copied from gene... need to check to see if it makes sense
    interaction = DataModel::Interaction.for_show.where('lower(genes.name) = ?', params[:name].downcase)
      .first || not_found("#{params[:name]} wasn't found!")
    @interaction = InteractionPresenter.new(interaction)
    @title = @interaction.display_name
  end
end
