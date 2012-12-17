class InteractionSearchResultsPresenter
  include Genome::Extensions
  attr_reader :search_results, :filter

  def initialize(search_results, params, start_time)
    @start_time = start_time
    @search_results = search_results
    @filter = params[:filter]
    @filter_scope = {}
    @source_scope = {}
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

  def each_result(context)
    @search_results.each do |result|
      yield OpenStruct.new(
        search_term: result.search_term,
        match_type: match_type(result),
        matches_with_links: (result.groups.map do |g|
          context.instance_exec{link_to g.name, gene_path(g.name)}
        end.join(", ") + " ").html_safe)
    end
  end

  def source_db_names_for_table
    definite_interactions(:filtered).map{|i| i.interaction.citation.source_db_name}.flatten.uniq.sort
  end

  def interactions_map_by_source_db_names
    unless @interactions_map_by_source_db_names
      interaction_groups = definite_interactions(:filtered).inject(Hash.new() {|hash, key| hash[key] = []}) do |hash, presenter|
        name = [presenter.drug_name, presenter.gene_group_display_name].join(" and ")
        hash[name] << presenter
        hash
      end
      master_source_list = source_db_names_for_table
      @interactions_map_by_source_db_names = interaction_groups.inject([]) do |array, (name, group)|
        group_sources = group.map{|g| g.source_db_name}
        array << OpenStruct.new(
          name: name,
          sources: master_source_list.map{|s| group_sources.include?(s)},
        )
      end
    end
    @interactions_map_by_source_db_names
  end

  def interactions_by_gene
    unless @interactions_by_gene
      passed_interactions_by_gene = definite_interactions(:filtered).inject(Hash.new() {|hash, key| hash[key] = []}) do |hash, presenter|
        hash[presenter.gene_group_name] << presenter
        hash
      end
      failed_interactions_by_gene = definite_interactions(:unfiltered).inject(Hash.new() {|hash, key| hash[key] = []}) do |hash, presenter|
        hash[presenter.gene_group_name] << presenter
        hash
      end
      gene_names = (passed_interactions_by_gene.keys + failed_interactions_by_gene.keys).uniq
      @interactions_by_gene = gene_names.inject([]) do |array, gene_name|
        presenters = passed_interactions_by_gene[gene_name] + failed_interactions_by_gene[gene_name]
        array << OpenStruct.new(
          search_term: presenters.first.search_term,
          gene_name: gene_name,
          gene_display_name: presenters.first.gene_group_display_name,
          passed_drug_count: passed_interactions_by_gene[gene_name].map{|i| i.drug_name}.uniq.count,
          failed_drug_count: failed_interactions_by_gene[gene_name].map{|i| i.drug_name}.uniq.count,
          category_list: presenters.first.potentially_druggable_categories
        )
        array
      end
    end
    @interactions_by_gene
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
      hash.merge!( result.interactions.uniq.select{|i| @source_scope[i.id] }.group_by{ |i| @filter_scope[i.id]  ? :filtered : :unfiltered } ) do |key, oldval, newval|
        oldval += newval.map{ |interaction| InteractionSearchResultPresenter.new(interaction, result.search_term) }
      end
      hash
    end
  end
end
