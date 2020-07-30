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
    results_for_view(Maybe(grouped_results[:ambiguous]))
  end

  def definite_results
    results_for_view(Maybe(grouped_results[:definite]))
  end

  def no_results_results
    Maybe(grouped_results[:no_results])
  end

  def ambiguous_no_interactions
    results_for_view(Maybe(grouped_results[:ambiguous_no_interactions]))
  end

  def definite_no_interactions
    results_for_view(Maybe(grouped_results[:definite_no_interactions]))
  end

  def scores_for_result(result, grouped_results)
    identifier = if @search_context == 'genes'
      :drug_id
    elsif @search_context == 'drugs'
      :gene_id
    end
    scores = result.interactions.values.flatten.each_with_object({}) do |result_interaction, h|
      overlap_count = grouped_results.map{ |r|
        r.interactions.values.flatten.count{|other_interaction| other_interaction.send(identifier) == result_interaction.send(identifier)}
      }.sum
      promiscuity_count = DataModel::Interaction.where(identifier => result_interaction.send(identifier)).count
      pub_count = result_interaction.publications.size
      source_count = result_interaction.sources.size
      all_promiscuity_counts = DataModel::Interaction.group(identifier).count.values.map{|x| 1/x}
      average_promiscuity = all_promiscuity_counts.sum / all_promiscuity_counts.size.to_f
      h[result_interaction.id] = ((pub_count + source_count) * (overlap_count * average_promiscuity / promiscuity_count)).round(2)
    end
  end

  private
  def grouped_results
    @grouped_results ||= @search_results.group_by { |result| result.partition }
  end

  def results_for_view(results)
    results.to_a
      .select{|result| !result.identifiers.empty?}
      .map{ |result| {
          term: result.search_term,
          identifiers: result.identifiers,
          interactions: result.interactions,
          scores: scores_for_result(result, results),
      }}
  end
end
