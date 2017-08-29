class InteractionSearchResultsApiV2Presenter
  def initialize(search_results)
    @search_results = search_results
  end

  def matched_results
    @matched_results ||= @search_results
      .select { |r| r.is_definite? }
      .map { |r| InteractionSearchResultApiV2Presenter.new(r) }
  end

  def unmatched_results
    @unmatched_results ||= @search_results
      .select { |r| !r.has_results? }
  end

  def ambiguous_results
    @ambiguous_results ||= @search_results
      .select { |r| r.is_ambiguous? }
  end
end
