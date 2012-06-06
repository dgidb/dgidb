class StaticController < ApplicationController
  def search_families
    @family_names = DataModel::GeneAlternateName.where(nomenclature: "human_readable_name").uniq.pluck(:alternate_name)
  end

end
