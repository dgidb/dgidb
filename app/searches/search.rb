class Search
  class << self
    def search(search_term)
      raise "You must specify a search term!" if (search_term.nil? || search_term.empty?)
      search_term += ":*"

      [].tap do |results|
        results.concat DataModel::Gene.search_by_name(search_term)
        results.concat DataModel::Drug.search_by_name(search_term)
        results.concat DataModel::GeneClaimAlias.search_by_alias(search_term)
        results.concat DataModel::DrugClaimAlias.search_by_alias(search_term)
        results.concat DataModel::GeneClaim.search_by_name(search_term)
        results.concat DataModel::DrugClaim.search_by_name(search_term)

        #TODO: these are ready to eager load the needed fields for the search result pages
        #but eager loading doesn't play nice with texticle...
        #results.concat DataModel::Gene.includes(:gene_claims).search_by_name(search_term)
        #results.concat DataModel::Drug.includes(:drug_claims).search_by_name(search_term)
        #results.concat DataModel::GeneClaimAlias.includes(gene_claim: [:source]).search_by_alias(search_term)
        #results.concat DataModel::DrugClaimAlias.includes(drug_claim: [:source]).search_by_alias(search_term)
        #results.concat DataModel::GeneClaim.includes(:source).search_by_name(search_term)
        #results.concat DataModel::DrugClaim.includes(:source).search_by_name(search_term)
      end.map{ |r| SearchResultPresenter.new(r) }
    end
  end
end
