class InteractionSearchResultsPresenter
  include Genome::Extensions
  attr_reader :search_results

  def initialize(search_results, view_context)
    @search_results = search_results
    @search_context = search_results[0].type
  end

  def number_of_search_terms
    @search_results.count
  end

  def get_context
    @search_context
  end

  def ambiguous_results
    Maybe(grouped_results[:ambiguous])
  end

  def definite_results
    Maybe(grouped_results[:definite])
  end

  def no_results_results
    Maybe(grouped_results[:no_results])
  end

  def ambiguous_no_interactions
    Maybe(grouped_results[:ambiguous_no_interactions])
  end

  def definite_no_interactions
    Maybe(grouped_results[:definite_no_interactions])
  end

  private
  def grouped_results
    @grouped_results ||= @search_results.group_by { |result| result.partition }
  end
end
