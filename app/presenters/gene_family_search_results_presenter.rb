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
