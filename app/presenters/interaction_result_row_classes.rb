module InteractionResultRowClasses
  class SearchTermSummary
    attr_reader :search_term, :match_type
    def initialize(search_term, match_type, ids, context)
      @search_term = search_term
      @match_type = match_type
      @ids = ids
      @context = context
    end

    def gene_links
      if match_type == 'None'
        'None'
      else
        @ids
        .map { |g| @context.link_to(g.name, @context.gene_path(g.name))}
        .join(', ').html_safe
      end
    end

    def drug_links
      if match_type == 'None'
        'None'
      else
        @ids
        .map { |d| @context.link_to(d.name, @context.drug_path(CGI::escape(d.name)))}
        .join(', ').html_safe
      end
    end
  end

  class InteractionBySource
    attr_reader :names, :sources, :pmids, :score
    def initialize(names, source_db_names, identifiers)
      @names = names
      identifier_sources = identifiers.map(&:source_db_name)
      @sources  = source_db_names.map { |s| identifier_sources.include?(s) }
      pmid_claims = identifiers.flat_map(&:pmids)
      @pmids = pmid_claims.map{ |pc| pc.value }.uniq
      @score = @sources.count(true) + @pmids.count
      # TODO: Expert sources * 2 + Non-expert sources + PMIDs
      if @score == 100
        raise "boom"
      end
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

  class InteractionByDrug
    attr_reader :search_term, :drug_name

    def initialize(drug_name, interaction_presenters)
      presenter = interaction_presenters.first
      @drug_name = drug_name
      @search_term = presenter.search_term
      @interactions = interaction_presenters
    end

    def gene_count
      @interactions.map(&:gene_claim_name).uniq.count
    end
  end
end
