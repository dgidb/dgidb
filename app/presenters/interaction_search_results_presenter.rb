class InteractionSearchResultsPresenter
  include Genome::Extensions
  include InteractionResultValueClasses
  attr_reader :search_results

  def initialize(search_results, start_time)
    @start_time = start_time
    @search_results = search_results
  end

  def number_of_search_terms
    @search_results.count
  end

  def number_of_definite_matches
    @search_results.select{ |r| r.genes.count == 1 }.count
  end

  def number_of_ambiguous_matches
    @search_results.select{ |r| r.genes.count > 1 }.count
  end

  def number_of_no_matches
    @search_results.select{ |r| r.genes.count == 0 }.count
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

  def time_elapsed(context)
   context.instance_exec(@start_time) do |start_time|
     distance_of_time_in_words(start_time, Time.now, true)
   end
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

  def search_term_summaries(context)
    @search_results.map do |result|
      gene_links = if result.match_type_label == 'None'
                     'None'
                   else
                     result.genes
                     .map { |g| context.instance_exec { link_to(g.name, gene_path(g.name)) } }
                     .join(', ').html_safe
                   end

      SearchTermSummary.new(result.search_term, result.match_type_label, gene_links)
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
      interaction_groups = definite_interactions.group_by do |presenter|
        [presenter.drug_claim_name, presenter.gene_name].join(" and ")
      end
      @interactions_map_by_source_db_names = interaction_groups.map do |name, gene|
        gene_sources = gene.map(&:source_db_name)
        InteractionNameWithSources.new(name, source_db_names_for_table.map{ |s| gene_sources.include?(s) })
      end
    end
    @interactions_map_by_source_db_names
  end

  def interactions_by_gene
    @interactions_by_gene ||= definite_interactions.group_by(&:gene_name).map do |gene_name, interactions|
      presenter = interactions.first
      InteractionByGene.new(
        presenter.search_term,
        gene_name,
        presenter.gene_long_name,
        interactions.map(&:drug_claim_name).uniq.count,
        presenter.potentially_druggable_categories
      )
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
        .map { |ic| InteractionSearchResultPresenter.new(ic, result.search_term) }
    end
  end
end
