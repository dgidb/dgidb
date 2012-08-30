class SearchController < ApplicationController
  def search_results
    @search_active = "active"
    @search_results = Search.search(params[:search_term])
  end
end
