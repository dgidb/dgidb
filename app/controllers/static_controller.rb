class StaticController < ApplicationController
  before_filter :set_active

  def search_categories
    @category_names = LookupCategories.get_uniq_category_names_with_counts.sort_by{|c| c.category_value}
  end

  def search_interactions
    @sources = DataSources.uniq_source_names_with_interactions.sort
  end

  private
  @@help_pages = ["getting_started", "faq", "downloads", "contact"]
  def set_active
    @@help_pages.include?(params[:action]) ? instance_variable_set("@help_active", "active") : instance_variable_set("@#{params[:action]}_active", "active")
  end

end
