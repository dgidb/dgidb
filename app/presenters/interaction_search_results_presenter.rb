class InteractionSearchResultsPresenter
  include Genome::Extensions
  include InteractionResultRowClasses
  attr_reader :search_results

  def initialize(search_results, start_time, view_context)
    @start_time = start_time
    @search_results = search_results
    @search_context = search_results[0].type
    @view_context = view_context
  end

  def number_of_search_terms
    @search_results.count
  end

  def get_context
    @search_context
  end

  def number_of_definite_matches
    @search_results.select{ |r| r.identifiers.count == 1 }.count
  end

  def number_of_ambiguous_matches
    @search_results.select{ |r| r.identifiers.count > 1 }.count
  end

  def number_of_no_matches
    @search_results.select{ |r| r.identifiers.count == 0 }.count
  end

  def number_of_definite_interactions
   definite_interactions.count
  end

  def number_of_ambiguous_interactions
   ambiguous_interactions.count
  end

  def number_of_search_terms_with_at_least_one_interaction
    @search_results.select{ |x| x.interaction_claims.count > 0 }.count
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

  def time_elapsed
   @view_context.distance_of_time_in_words(@start_time, Time.now, true)
  end

  def definite_interactions
    @definite_interactions ||= interaction_result_presenters(definite_results)
  end

  def ambiguous_interactions
    @ambiguous_interactions ||= interaction_result_presenters(ambiguous_results)
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

  def search_term_summaries
    @search_results.map do |result|
      SearchTermSummary.new(result.search_term, result.match_type_label, result.identifiers, @view_context)
    end
  end

  def source_db_names_for_table
    @source_db_names_for_table ||= definite_interactions
      .flat_map { |i| i.source_db_name }
      .uniq
      .sort
  end

  def interactions_map_by_source_db_names
    unless @interactions_map_by_source_db_names
      if @search_context == 'genes'
        interaction_groups = definite_interactions.group_by do |presenter|
          { gene: presenter.gene_name, drug: presenter.drug_name }
        end
      else
        interaction_groups = definite_interactions.group_by do |presenter|
          { drug: presenter.drug_name, gene: presenter.gene_name}
        end
      end
      @interactions_map_by_source_db_names = interaction_groups.map do |names, ids|
        InteractionBySource.new(names, source_db_names_for_table, ids)
      end
    end
    @interactions_map_by_source_db_names
  end

  def interactions_by_gene
    @interactions_by_gene ||= definite_interactions.group_by(&:gene_name).map do |gene_name, interactions|
      InteractionByGene.new(gene_name, interactions)
    end
  end

  def interactions_by_drug
    @interactions_by_drug ||= definite_interactions.group_by(&:drug_name).map do |drug_name, interactions|
      InteractionByDrug.new(drug_name, interactions)
    end
  end

  private
  def grouped_results
    @grouped_results ||= @search_results.group_by { |result| result.partition }
  end

  def interaction_result_presenters(result_list)
    result_list.flat_map do |result|
      result.interaction_claims
        .sort_by { |ic| InteractionResultSortOrder.sort_value(ic.source.source_db_name) }
        .map { |ic| InteractionSearchResultPresenter.new(ic, result.search_term, @view_context) }
    end
  end
end
