class GeneClaimPresenter < SimpleDelegator

  def title
    @title ||= if(gene && name != gene.name)
      "#{name} (#{gene.name})"
    else
      name
    end
  end

  def gene_link(context)
    #the instance exec creates a closure around the local scope
    #this hack stores the result of the "gene" method call in a "gene"
    #variable so that its available in that closure
    if g = gene
      context.instance_exec { link_to g.name, gene_path(g.name) }
    else
      'N/A'
    end
  end

  def publications
    interaction_claims.map{|ic| ic.publications}.flatten.uniq
  end

  def data
    {
      source: source.source_db_name,
      name: name,
      aliases: gene_claim_aliases.map(&:alias),
      attributes: gene_claim_attributes.map{|a| ClaimAttributePresenter.new(a).data},
      publications: publications.map(&:pmid),
    }
  end

end
