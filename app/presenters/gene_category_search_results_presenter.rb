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

  def pass_filtered_categories
    grouped_results[:pass]
  end

  def fail_filtered_categories
    grouped_results[:fail]
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

  def show_pass_categories?
    !grouped_results[:pass].nil? && grouped_results[:pass].count > 0
  end

  def show_fail_categories?
    !grouped_results[:fail].nil? && grouped_results[:fail].count > 0
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

  def failed_groups_by_category
    unless @failed_groups_by_category
      @failed_groups_by_category = []
      fail_filtered_categories.group_by do |category|
        category.gene_category
      end.each_pair do |category, results|
        groups = results.map{|x| x.group_name}
        group_display_names = results.inject({}) {| map, result | map.tap {|h| h[result.group_display_name] = result.group_name } }
        @failed_groups_by_category << OpenStruct.new(
          category_name: category,
          groups: groups,
          group_display_names: group_display_names,
          group_count: groups.count
        )
      end
    end
    @failed_groups_by_category
  end

  def passed_groups_by_category
    unless @passed_groups_by_category
      @passed_groups_by_category = []
      all_passed_groups = grouped_results[:pass].map{|r| r.group_name}.uniq 
      pass_filtered_categories.group_by do |category|
        category.gene_category
      end.each_pair do |category, results|
        groups = results.map{|x| x.group_name}
        group_display_names = results.inject({}) {| map, result | map.tap {|h| h[result.group_display_name] = result.group_name } }
        sources = groups.map{|x| DataModel::GeneGroup.where(name: x).first.potentially_druggable_genes.select{|g| g.gene_categories.map{|c| c.category_value}.include?(category)}.map{|g| g.citation.source_db_name}}.flatten
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
  def grouped_results
    @grouped_results ||= category_map(@search_results.group_by { |result| result.partition }[:definite])
  end

  def category_map(result_list)
   results = Maybe(result_list).inject({:pass => [], :fail => []}) do |hash, result|
      hash[:pass] += result.gene_categories.uniq.select{ |i| @category_scope[i]  }.map do |category|
        GeneCategorySearchResultPresenter.new(category, result.search_term, result.gene_group_name, result.gene_group_display_name)
      end
      hash[:fail] += result.gene_categories.uniq.reject{ |i| @category_scope[i]  }.map do |category|
        GeneCategorySearchResultPresenter.new(category, result.search_term, result.gene_group_name, result.gene_group_display_name)
      end
      hash
    end

   results[:pass] = results[:pass].inject({}) do |hash, result|
     key = result.gene_category + "-" +result.group_name
     if hash.has_key?(key)
       hash[key].search_term += ", #{result.search_term}"
     else
       hash[key] = result
     end
     hash
   end.values

   results[:fail] = results[:fail].inject({}) do |hash, result|
     key = result.gene_category + "-" +result.group_name
     if hash.has_key?(key)
       hash[key].search_term += ", #{result.search_term}"
     else
       hash[key] = result
     end
     hash
   end.values
   results
  end
end
