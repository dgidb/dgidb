class StaticController < ApplicationController
  def search_categories
    @category_names = LookupCategories.get_uniq_category_names_with_counts.sort_by{|c| c.name}
    @search_categories_active = "active"
  end

  def search_interactions
    @search_interactions_active = "active"
    @sources = DataSources.uniq_source_names_with_interactions.sort
  end

  def search
    @search_active = "active"
  end

  def about
    @about_active = "active"
    @sources = DataSources.uniq_source_names.sort
  end

  def contact
    @contact_active = "active"
  end

end
