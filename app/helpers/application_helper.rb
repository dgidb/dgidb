module ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context   
  def tx( fragment_id, action = params['action'] )
    action_hash = Maybe(EXTERNAL_STRINGS[action])
    if !action_hash[fragment_id].nil?
      action_hash[fragment_id].html_safe
    else
      ""
    end
  end

  def to( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id]
  end

  def label(content, type = 'success')
    content_tag(:span, content, class: ['label', "label-#{type}"])
  end

  def icon( icon_name, content = nil, opts = {}, &block )
    if opts.empty? && content.is_a?( Hash )
      opts = content
      content = nil
    end
    content = capture( &block ) if block_given?
    opts[:class] = Array( opts[:class] ).push "icon-#{icon_name}"
    content_tag( :i, content, opts )
  end

  def ext_link_to(*args)
    link_to(*args) + icon('share')
  end

  def dynamic_link_to(title, link)
    if /^(http|https):\/\// =~ link then
      ext_link_to(title, link)
    else
      link_to(title, link)
    end
  end

  def pubmed_link_to(pmid)
    link = "http://www.ncbi.nlm.nih.gov/pubmed/" + pmid.to_s
    title = "PMID" + pmid.to_s
    dynamic_link_to(title, link)
  end

  def pubmed_link_blue(pmid)
    type = 'primary'
    link = "http://www.ncbi.nlm.nih.gov/pubmed/" + pmid.to_s
    link_to(label(pmid, type), link)
  end

  def gene_claim_path(gene_claim)
    "/gene_claims/#{gene_claim.source.source_db_name}/#{gene_claim.name}"
  end

  def drug_claim_path(drug_claim)
    "/drug_claims/#{drug_claim.source.source_db_name}/#{drug_claim.name}"
  end

  def cache_key_for_druggable_category(sources, category_name)
    sources.hash.to_s + category_name
  end

  def download_link(filename)
    link_to("/downloads/#{filename}")
  end

  def flag_help(flags)
    content_tag :span do
      flags.collect do |text, type|
        content_tag(:span, text, class: ['label', 'label-' + type, "flag_icon"])
      end.join.html_safe
    end
  end

end
