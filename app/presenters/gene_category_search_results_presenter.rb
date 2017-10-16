class GeneCategorySearchResultsPresenter
  include Genome::Extensions
  def initialize(search_results, params, start_time, view_context)
    @start_time = start_time
    @search_results = search_results
    @view_context = view_context
  end

  def number_of_search_terms
    @search_results.count
  end

  def number_of_definite_matches
    @search_results.select { |r| r.partition == :definite }.count
  end

  def number_of_ambiguous_matches
    ambiguous_results.count
  end

  def number_of_no_matches
    no_results_results.count
  end

  def no_results_results
    @no_results_results ||= @search_results.reject { |r| r.has_results? }
  end

  def ambiguous_results
    @ambiguous_results ||= @search_results.select { |i| i.partition == :ambiguous }
  end

  def definite_results_with_no_categories
    @definite_results_with_no_categories ||= @search_results.select{|i| i.partition == :definite && i.gene_categories.count == 0 }
  end

  def time_elapsed
    @view_context.distance_of_time_in_words(@start_time, Time.now, include_seconds: true)
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
      all_gene_names = result_presenters.map{ |r| r.gene_name }.uniq
      result_presenters.group_by { |presenter|  presenter.gene_category }
        .each do |category, results|
          sources = results.flat_map { |r| r.gene.gene_claims }
            .select { |gc| gc.gene_claim_categories
                .select { |gcc| gcc.name == category }.any?
            }.map { |gc| gc.source.source_db_name }
          gene_names_in_category = results.map(&:gene_name)
          @genes_by_category << OpenStruct.new(
            category_name: category,
            genes: gene_names_in_category,
            non_matched_genes: all_gene_names - gene_names_in_category,
            gene_count: gene_names_in_category.count,
            sources: sources
          )
        end
    end
    @genes_by_category
  end

  def unique_matches
    unless @unique_matches
      @unique_matches = []
      results = result_presenters.uniq{|r| r.gene_categories}
      results.each do |result|
        gene = result.genes[0]
        gene_claims = result.gene_claims
        categories = result.gene_categories
        rows = []
        categories.each do |category|
          sources = gene_claims
            .select { |gc| gc.gene_claim_categories.select { |gcc| gcc.name == category }.any?}
            .map { |gc| gc.source.source_db_name }
          rows << OpenStruct.new(
              category: category,
              sources: sources
            )
        end
        @unique_matches << OpenStruct.new(
            search_terms: result.search_terms,
            gene_name: gene.name,
            rows: rows
          )
      end
    end
    @unique_matches
  end

  def ambiguous_matches
    unless @ambiguous_matches
      @ambiguous_matches = []
      results = ambiguous_result_presenters.uniq{|r| r.gene_categories}
      results.each do |result|
        genes = result.genes
        genes.each do |gene|
          gene_claims = gene.gene_claims
          categories = gene.gene_categories.uniq
          rows = []
          categories.each do |category|
            sources = gene_claims
              .select { |gc| gc.gene_claim_categories.select { |gcc| gcc.name == category.name }.any?}
              .map { |gc| gc.source.source_db_name }
            rows << OpenStruct.new(
                category: category.name,
                sources: sources
              )
          end
          @ambiguous_matches << OpenStruct.new(
              search_terms: result.search_terms,
              gene_name: gene.name,
              rows: rows
            )
        end
      end
    end
    @ambiguous_matches
  end

  def source_db_names_for_table
    @source_db_names ||= genes_by_category.map{|x| x.sources}.flatten.uniq.sort
  end

  def categories_map_by_source_db_names
    unless @categories_map_by_source_db_names
      sources = source_db_names_for_table
      @categories_map_by_source_db_names = genes_by_category.inject([]) do |array, gene|
        array << OpenStruct.new(
          name: gene.category_name,
          sources: sources.map{|s| gene.sources.count(s)}
        )
      end
    end
    @categories_map_by_source_db_names
  end

  def show_genes_by_category?
    genes_by_category.count > 0
  end

  def result_presenters
    @result_presenters ||= gene_category_result_presenters(@search_results.group_by { |result| result.partition }[:definite] || [])
  end

  def ambiguous_result_presenters
    @ambiguous_result_presenters ||= gene_category_result_presenters(@search_results.group_by { |result| result.partition }[:ambiguous] || [])
  end

  private
  def gene_category_result_presenters(result_list)
    result_list.flat_map do |result|
      result.gene_categories.uniq.map do |category|
        GeneCategorySearchResultPresenter.new(category, result, @view_context)
      end
    end
  end
end
