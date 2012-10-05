class SourcesController < ApplicationController
  caches_page :sources, :show
  def show
    @source = DataSources.data_source_summary_by_source_db_name(params[:source_db_name])
    @source.found? || not_found("This source doesn't exist in our system!")
    @title = @source.name
  end

  def sources
    @help_active = 'active'
    @sources = DataSources.all_source_summaries
  end

end
