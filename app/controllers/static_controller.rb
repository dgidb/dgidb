class StaticController < ApplicationController
  def search_families
    @family_names = LookupFamilies.get_uniq_family_names
  end

end
