module InteractionResultValueClasses
    SearchTermSummary = Struct.new(:search_term, :match_type, :gene_links)
    InteractionNameWithSources = Struct.new(:name, :sources)
    InteractionByGene = Struct.new(:search_term, :gene_name, :gene_display_name, :drug_count, :category_list)
end
