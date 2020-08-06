class SourcePresenter < SimpleDelegator

  def initialize(source, view_context)
    @view_context = view_context
    super(source)
  end

  def type
    source_type.type
  end

  def type_display_name
    source_type.display_name
  end

  def trust_level
    source_trust_level.level
  end

  def interaction_precedence
    sort_order_to_string(InteractionResultSortOrder, source_db_name)
  end

  def category_precedence
    sort_order_to_string(CategoryResultSortOrder, source_db_name)
  end

  def citation_with_pmid_link
    if match_data = citation.match(/PMID: (?<pmid_id>\d+)\.?$/)
      pmid_link = @view_context.ext_link_to(match_data['pmid_id'], "http://www.ncbi.nlm.nih.gov/pubmed/#{match_data['pmid_id']}")
      sprintf('%s PMID: %s %s',
              match_data.pre_match,
              pmid_link,
              match_data.post_match)
    else
     citation
    end
  end

  def license_linkout
    if license.present?
      if license_link.present?
          @view_context.ext_link_to(license, license_link)
      else
          license
      end
    else
      ""
    end
  end

  private
  def sort_order_to_string(sort_type, source_db_name)
    val = sort_type.sort_value(source_db_name)
    #todo - this is dumb and hardcoded
    if val == 99
      'N/A'
    else
      val.ordinalize
    end
  end
end
