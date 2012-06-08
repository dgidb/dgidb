include Genome::Extensions

class GeneFamilySearchResultsPresenter
  def initialize(search_results, params)
    @search_results = search_results
    @family_scope = params["families"].inject({}){|hash, family| hash[family] = true; hash}
  end

  def pass_filtered_families
    grouped_results[:pass]
  end

  def fail_filtered_families
    grouped_results[:fail]
  end

  def show_pass_families?
    grouped_results[:pass].count > 0
  end

  def show_fail_families?
    grouped_results[:fail].count > 0
  end

  def failed_groups_by_family
    unless @failed_groups_by_family
      @failed_groups_by_family = []
      fail_filtered_families.group_by do |family|
        family.gene_family
      end.each_pair do |family, results|
        groups = results.map{|x| x.group_name}
        @failed_groups_by_family << OpenStruct.new(family_name: family, groups: groups.join(", "), group_count: groups.count)
      end
    end
    @failed_groups_by_family
  end

  def passed_groups_by_family
    unless @passed_groups_by_family
      @passed_groups_by_family = []
      pass_filtered_families.group_by do |family|
        family.gene_family
      end.each_pair do |family, results|
        groups = results.map{|x| x.group_name}
        @passed_groups_by_family << OpenStruct.new(family_name: family, groups: groups.join(", "), group_count: groups.count)
      end
    end
    @passed_groups_by_family
  end


  def show_passed_groups_by_family?
    passed_groups_by_family.count > 0
  end

  def show_failed_groups_by_family?
    failed_groups_by_family.count > 0
  end

  private
  def grouped_results
    @grouped_results ||= family_map(@search_results.group_by { |result| result.partition }[:definite])
  end

  def family_map(result_list)
   results = result_list.inject({:pass => [], :fail => []}) do |hash, result|
      hash[:pass] += result.gene_families.uniq.select{ |i| @family_scope[i]  }.map do |family|
        GeneFamilySearchResultPresenter.new(family, result.search_term, result.gene_group_name)
      end
      hash[:fail] += result.gene_families.uniq.reject{ |i| @family_scope[i]  }.map do |family|
        GeneFamilySearchResultPresenter.new(family, result.search_term, result.gene_group_name)
      end
      hash
    end

   results[:pass] = results[:pass].inject({}) do |hash, result|
     key = result.gene_family + "-" +result.group_name
     if hash.has_key?(key)
       hash[key].search_term += ", #{result.search_term}"
     else
       hash[key] = result
     end
     hash
   end.values

   results[:fail] = results[:fail].inject({}) do |hash, result|
     key = result.gene_family + "-" +result.group_name
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
