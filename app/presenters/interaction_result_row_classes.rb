module InteractionResultRowClasses
  class SearchTermSummary
    attr_reader :search_term, :match_type
    def initialize(search_term, match_type, genes, context)
      @search_term = search_term
      @match_type = match_type
      @genes = genes
      @context = context
    end

    def gene_links
      if match_type == 'None'
        'None'
      else
        @genes
        .map { |g| @context.instance_exec { link_to(g.name, gene_path(g.name)) } }
        .join(', ').html_safe
      end
    end
  end

  class InteractionNameWithSources
    attr_reader :name, :sources
    def initialize(name, source_db_names, genes)
      @name = name
      gene_sources = genes.map(&:source_db_name)
      @sources  = source_db_names.map { |s| gene_sources.include?(s) }
    end
  end

  class InteractionByGene
    attr_reader :search_term, :gene_name, :gene_display_name, :category_list

    def initialize(gene_name, interaction_presenters)
      presenter = interaction_presenters.first
      @gene_name = gene_name
      @search_term = presenter.search_term
      @gene_display_name = presenter.gene_long_name
      @interactions = interaction_presenters
      @category_list = presenter.potentially_druggable_categories
    end

    def drug_count
      @interactions.map(&:drug_claim_name).uniq.count
    end
  end
end
