class StaticController < ApplicationController
  def search_families
    @family_names = LookupFamilies.get_uniq_family_names
    @search_families_active = "active"
  end

  def search_interactions
    @search_interactions_active = "active"
  end

  def about
    @about_active = "active"
  end

  def contact
    @contact_active = "active"
  end

end
