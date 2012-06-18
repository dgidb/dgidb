include Genome::Extensions

class InteractionSearchResultsPresenter
  attr_reader :results, :filter

  def initialize(search_results, params, start_time)
    @start_time = start_time
    @search_results = search_results
    @filter = params[:filter]
    @filter_scope = DataModel::Interaction.send(@filter)
    @source_scope = DataModel::Interaction.source_scope(params)
  end

  def number_of_search_terms
    @search_results.count
  end

  def number_of_definite_matches
    @search_results.select{|r| r.groups.count == 1}.count
  end

  def number_of_ambiguous_matches
    @search_results.select{|r| r.groups.count > 1}.count
  end

  def number_of_no_matches
    @search_results.select{|r| r.groups.count == 0}.count
  end

  def number_of_definite_interactions
   definite_interactions(:filtered).count + definite_interactions(:unfiltered).count
  end

  def number_of_ambiguous_interactions
   ambiguous_interactions(:filtered).count + ambiguous_interactions(:unfiltered).count
  end

  def number_of_search_terms_with_at_least_one_interaction
    @search_results.select{|x| x.interactions.count > 0}.count
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

  def time_elapsed(context)
   context.instance_exec(@start_time){|start_time| distance_of_time_in_words(start_time, Time.now, true)}
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

  def each_result
    @search_results.each do |result|
      yield OpenStruct.new(search_term: result.search_term, match_type: match_type(result), matches: result.groups.map{|g| g.name}.join(", ") + " "  )
    end
  end

  private

  def match_type(result)
    if result.groups.count == 0
      "None"
    elsif result.groups.count == 1
      "Definite"
    else
      "Ambiguous"

    end
  end

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
