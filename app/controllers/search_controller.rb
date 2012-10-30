class SearchController < ApplicationController
  def search_results
    validate_search_request(params)
    @search_results = Search.search(params[:search_term])
  end

  private
  def validate_search_request(params)
    bad_request("Please enter a search term!") if params[:search_term].blank?
  end

end
