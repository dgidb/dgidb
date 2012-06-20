include Genome::Extensions

class GeneCategorySearchResultsPresenter
  def initialize(search_results, params)
    @search_results = search_results
    @category_scope = params["categories"].inject({}){|hash, category| hash[category] = true; hash}
  end

  def pass_filtered_categories
    grouped_results[:pass]
  end

  def fail_filtered_categories
    grouped_results[:fail]
  end

  def show_pass_categories?
    grouped_results[:pass].count > 0
  end

  def show_fail_categories?
    grouped_results[:fail].count > 0
  end

  def failed_groups_by_category
    unless @failed_groups_by_category
      @failed_groups_by_category = []
      fail_filtered_categories.group_by do |category|
        category.gene_category
      end.each_pair do |category, results|
        groups = results.map{|x| x.group_name}
        @failed_groups_by_category << OpenStruct.new(category_name: category, groups: groups.join(", "), group_count: groups.count)
      end
    end
    @failed_groups_by_category
  end

  def passed_groups_by_category
    unless @passed_groups_by_category
      @passed_groups_by_category = []
      pass_filtered_categories.group_by do |category|
        category.gene_category
      end.each_pair do |category, results|
        groups = results.map{|x| x.group_name}
        @passed_groups_by_category << OpenStruct.new(category_name: category, groups: groups.join(", "), group_count: groups.count)
      end
    end
    @passed_groups_by_category
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
   results = result_list.inject({:pass => [], :fail => []}) do |hash, result|
      hash[:pass] += result.gene_categories.uniq.select{ |i| @category_scope[i]  }.map do |category|
        GeneCategorySearchResultPresenter.new(category, result.search_term, result.gene_group_name)
      end
      hash[:fail] += result.gene_categories.uniq.reject{ |i| @category_scope[i]  }.map do |category|
        GeneCategorySearchResultPresenter.new(category, result.search_term, result.gene_group_name)
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
