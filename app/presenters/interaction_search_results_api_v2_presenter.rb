class InteractionSearchResultsApiV2Presenter
  def initialize(search_results)
    @search_results = search_results
  end

  def matched_results
    @matched_results ||= @search_results
      .select { |r| r.is_definite? }
      .flat_map { |r| r.interactions.map { |identifier, interactions| InteractionSearchResultApiV2Presenter.new(r, identifier, interactions) }}
  end

  def unmatched_results
    @unmatched_results ||= @search_results
      .select { |r| !r.has_results? }
  end

  def ambiguous_results
    @ambiguous_results ||= @search_results
      .select { |r| r.is_ambiguous? }
      .flat_map { |r| r.interactions.map { |identifier, interactions| InteractionSearchResultApiV2Presenter.new(r, identifier, interactions) } }
  end
end
