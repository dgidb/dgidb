module ApplicationHelper
  def tx( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id].html_safe
  end

  def to( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id]
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

  def link_for_drug(drug)
    link_to(drug.name, "/drugs/#{drug.name}")
  end
  
  def links_for_gene_claim(gene_claim)
    gene = gene_claim.genes.first
    link_to(gene_claim.name, "/gene_claims/#{gene_claim.source_db_name}/#{gene_claim.name}") + 
      " (" + link_to("sources for #{gene.name}", "/genes/#{gene.name}") + ")"  
  end

  def links_for_drug_claim(drug_claim)
    drug = drug_claim.drugs.first
    
    # link = link_to(drug_claim.name, "/drug_claims/#{drug_claim.source.source_db_name}/#{drug_claim.name}")
    link = link_to(drug_claim.name, "/drug_claims/#{drug_claim.name}")
    if (drug != nil) 
      # not all drug_claims are grouped under a canonical "drug"
      link = link + "  (" + link_to("sources for #{drug.name}", "/drugs/#{drug.name}") + ")"  
    end

    # stick with old display which just has the drug_claim name for now... 
    #link_to(drug_claim.name, "/drug_claims/#{drug_claim.name}") 
    return link
  end

  def title_for_gene_claim(gene_claim)
    gene = gene_claim.genes.first
    if (gene != nil and gene_claim.name != gene.name) 
      gene_claim.name + ' (' + gene.name + ')'
    else
      gene_claim.name
    end
  end

  def title_for_drug_claim(drug_claim)
    drug = drug_claim.drugs.first
    if (drug != nil and drug_claim.name != drug.name) 
      drug_claim.name + ' (' + drug.name + ')'
    else
      drug_claim.name
    end
  end

  def title_for_interaction_claim(interaction_claim)
    drug_claim = interaction_claim.drug_claim
    gene_claim = interaction_claim.gene_claim
    "#{title_for_drug_claim(drug_claim)} acting on #{title_for_gene_claim(gene_claim)}"
  end
end
