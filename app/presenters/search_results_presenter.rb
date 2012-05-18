include Genome::Extensions

class SearchResultsPresenter
  def initialize(search_results)
    @search_results = search_results
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

  def definite_interactions
    @definite_interactions ||= interaction_map(definite_results)
  end

  def ambiguous_interactions
    @definite_interactions ||= interaction_map(ambiguous_results)
  end

  def show_definite?
    !grouped_results[:definite].nil?
  end

  def show_ambiguous?
    binding.pry
    !grouped_results[:ambiguous].nil?
  end

  private
  def grouped_results
    @grouped_results ||= @search_results.group_by do |result|
      if result.has_results?
        if result.is_ambiguous?
          :ambiguous
        else
          :definite
        end
      else
        :no_results
      end
    end
  end

  def interaction_map(result_list)
    result_list.inject([]) do |list, result|
      list += result.interactions.map do |interaction|
        InteractionSearchResultPresenter.new(interaction, result.search_term)
      end
    end
  end
end
