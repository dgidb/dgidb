class GeneCategorySearchResultsPresenter
  include Genome::Extensions
  def initialize(search_results, params, start_time)
    @start_time = start_time
    @search_results = search_results
    @category_scope = params["categories"].inject({}){|hash, category| hash[category] = true; hash}
  end

  def number_of_search_terms
    @search_results.count
  end

  def number_of_definite_matches
    @search_results.select{|r| r.groups.count == 1}.count
  end

  def number_of_ambiguous_matches
    ambiguous_results.count
  end

  def number_of_no_matches
    no_results_results.count
  end

  def no_results_results
    @no_results_results ||= @search_results.select{|i| i.groups.count == 0 }
  end

  def ambiguous_results
    @ambiguous_results ||= @search_results.select{|i| i.partition == :ambiguous}
  end

  def definite_results_with_no_categories
    @definite_results_with_no_categories ||= @search_results.select{|i| i.partition == :definite && i.gene_categories.count == 0 }
  end

  def time_elapsed(context)
    context.instance_exec(@start_time){|start_time| distance_of_time_in_words(start_time, Time.now, true)}
  end

  def show_result_categories?
    !result_presenters.nil? && result_presenters.count > 0
  end

  def show_definite_results_with_no_categories?
    !definite_results_with_no_categories.nil? && definite_results_with_no_categories.count > 0
  end

  def show_no_results_results?
    !no_results_results.nil? && no_results_results.count > 0
  end

  def show_ambiguous_results?
    !ambiguous_results.nil? && ambiguous_results.count > 0
  end

  def genes_by_category
    unless @genes_by_category
      @genes_by_category = []
      all_gene_names = result_presenters.map{ |r| r.group_name }.uniq
      result_presenters.group_by do |category|
        category.gene_claim_category
      end.each_pair do |category, results|
        gene_names = results.map{|x| x.gene_name}
        group_display_names = results.inject({}) { |map, result| map.tap { |h| h[result.gene_full_name] = result.gene_name } }
        sources = gene_names.map{|x| DataModel::Gene.where(name: x).first.potentially_druggable_genes.select{|g| g.gene_categories.map{|c| c.category_value}.include?(category)}.map{|g| g.citation.source_db_name}}.flatten
        @passed_groups_by_category << OpenStruct.new(
          category_name: category,
          groups: groups,
          group_display_names: group_display_names,
          non_matched_groups: all_passed_groups - groups,
          group_count: groups.count,
          sources: sources,
        )
      end
    end
    @passed_groups_by_category
  end

  def source_db_names_for_table
    passed_groups_by_category.map{|x| x.sources}.flatten.uniq.sort
  end

  def categories_map_by_source_db_names
    unless @categories_map_by_source_db_names
      sources = source_db_names_for_table
      @categories_map_by_source_db_names = passed_groups_by_category.inject([]) do |array, group|
        array << OpenStruct.new(
          name: group.category_name,
          sources: sources.map{|s| group.sources.count(s)}
        )
      end
    end
    @categories_map_by_source_db_names
  end

  def show_passed_groups_by_category?
    passed_groups_by_category.count > 0
  end

  def show_failed_groups_by_category?
    failed_groups_by_category.count > 0
  end

  private
  def result_presenters
    @result_presenters ||= gene_category_result_presenters(@search_results.group_by { |result| result.partition }[:definite])
  end

  def gene_category_result_presenters(result_list)
    results = result_list.flat_map do |result|
      result.gene_categories.uniq.select{ |i| @category_scope[i]  }.map do |category|
        GeneCategorySearchResultPresenter.new(category, result.search_term, result.gene_name, result.gene_full_name)
      end
    end

    results.inject({}) do |hash, result|
      key = result.gene_category + "-" +result.group_name
      if hash.has_key?(key)
        hash[key].search_term += ", #{result.search_term}"
      else
        hash[key] = result
      end
      hash
    end.values
  end
end
