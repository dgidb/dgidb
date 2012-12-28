class GeneClaimCategoriesController < ApplicationController

  def categories_for_selected_sources
    @category_names = DataModel::GeneClaimCategory.categories_in_sources(params[:selected_sources])
    render layout: false
  end

end
