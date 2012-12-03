class DruggableGeneCategoryPresenter
  include Genome::Extensions
  def initialize (search_results)
    @search_results = search_results
  end

  def results
    grouped_results
  end

  private 
  def grouped_results 
    @grouped_results ||= category_map(@search_results)
  end

  def category_map(result_hash)
    results = {}
    result_hash.each_pair do |category, stuff|
      results[category] = stuff.flat_map{|gan| gan.gene.gene_groups.map {|group| OpenStruct.new(gene_group: group, source_db_name: gan.gene.citation.source_db_name)}}.uniq.group_by{|s| s.gene_group} #TODO: make less badder
    end

    [].tap do |structs|
      results.each do |key, val|
        structs.concat(val.map{|gene_group, blah| OpenStruct.new(category: key, gene_group: gene_group, source_db_names: blah.map{|s| s.source_db_name})})
      end
    end
  end
end
