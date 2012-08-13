class SearchController < ApplicationController
  def search_results
    @search_active = "active"
    start_time = Time.now
    #do any validation here

    search_results = Search.search(params)
    @search_results = SearchResultsPresenter.new(search_results, params, start_time)
  end
end
