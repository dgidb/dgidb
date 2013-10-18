class Search
  def self.search(search_term)
    raise "You must specify a search term!" if search_term.blank?
    search_term += ":*"

    [].tap do |results|
      results.concat DataModel::Gene.includes(:gene_claims).advanced_search(name: search_term)
      results.concat DataModel::Drug.includes(:drug_claims).advanced_search(name: search_term)
      results.concat DataModel::GeneClaimAlias.includes(gene_claim: [:source]).advanced_search(alias: search_term)
      results.concat DataModel::DrugClaimAlias.includes(drug_claim: [:source]).advanced_search(alias: search_term)
      results.concat DataModel::GeneClaim.includes(:source).advanced_search(name: search_term)
      results.concat DataModel::DrugClaim.includes(:source).advanced_search(name: search_term)
    end.map{ |r| SearchResultPresenter.new(r) }
  end
end
