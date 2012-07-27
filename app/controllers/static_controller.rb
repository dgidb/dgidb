class StaticController < ApplicationController
  def search_categories
    @category_names = LookupCategories.get_uniq_category_names_with_counts
    @search_categories_active = "active"
  end

  def search_interactions
    @search_interactions_active = "active"
    @sources = DataSources.uniq_source_names_with_interactions
  end

  def about
    @about_active = "active"
    @sources = DataSources.uniq_source_names
  end

  def contact
    @contact_active = "active"
  end

end
