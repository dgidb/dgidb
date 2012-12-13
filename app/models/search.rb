class Search
  class << self
    def search(search_term)
      raise "You must specify a search term!" if (search_term.nil? || search_term.empty?)
      search_term += ":*"

      [].tap do |results|
        results.concat DataModel::Gene.search_by_name(search_term)
        results.concat DataModel::Drug.search_by_name(search_term)
        results.concat DataModel::GeneClaimAlias.search_by_alternate_name(search_term)
        results.concat DataModel::DrugClaimAlias.search_by_alternate_name(search_term)
        results.concat DataModel::GeneClaim.search_by_name(search_term)
        results.concat DataModel::DrugClaim.search_by_name(search_term)
      end.map{ |r| SearchResultPresenter.new(r) }
    end
  end
end
