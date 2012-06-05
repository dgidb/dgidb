include Genome::Extensions

class SearchResultsPresenter
  def initialize(search_results, params)
    @search_results = search_results
    @filter_scope = DataModel::Interaction.send(params[:filter])
    @source_scope = DataModel::Interaction.source_scope(params)
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

  def definite_interactions(filter_type)
    @definite_interactions ||= interaction_map(definite_results)
    @definite_interactions[filter_type]
  end

  def ambiguous_interactions(filter_type)
    @ambiguous_interactions ||= interaction_map(ambiguous_results)
    @ambiguous_interactions[filter_type]
  end

  def show_definite?
    !grouped_results[:definite].nil?
  end

  def show_ambiguous?
    !grouped_results[:ambiguous].nil?
  end

  def show_no_results_results?
    !grouped_results[:no_results].nil?
  end

  def show_ambiguous_no_interactions?
    !grouped_results[:ambiguous_no_interactions].nil?
  end

  def show_definite_no_interactions?
    !grouped_results[:definite_no_interactions].nil?
  end

  private
  def grouped_results
    @grouped_results ||= @search_results.group_by { |result| result.partition }
  end

  def interaction_map(result_list)
    result_list.inject({:filtered => [], :unfiltered => []}) do |hash, result|
      hash[:filtered] += result.interactions.uniq.select{ |i| @filter_scope[i.id] && @source_scope[i.id] }.map do |interaction|
        InteractionSearchResultPresenter.new(interaction, result.search_term)
      end
      hash[:unfiltered] += result.interactions.uniq.reject{ |i| @filter_scope[i.id] && @source_scope[i.id] }.map do |interaction|
        InteractionSearchResultPresenter.new(interaction, result.search_term)
      end
      hash
    end
  end
end
