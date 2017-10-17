class GeneDetailPresenter < GenePresenter
  def as_json
    super.merge(
      pmids: self.publications.map(&:pmid),
      attributes: gene.gene_attributes.map{|a| AttributePresenter.new(a).as_json},
      categories: gene.gene_categories.map(&:name),
      gene_claims: gene.gene_claims.map{|c| GeneClaimPresenter.new(c).as_json},
    )
  end
end
