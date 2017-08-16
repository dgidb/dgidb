class GeneDetailPresenter < GenePresenter
  def data
    super.merge(
      pmids: self.publications.map(&:pmid),
      attributes: gene.gene_attributes.map{|a| AttributePresenter.new(a).data},
      categories: gene.gene_categories.map(&:name),
      gene_claims: gene.gene_claims.map{|c| GeneClaimPresenter.new(c).data},
    )
  end
end
