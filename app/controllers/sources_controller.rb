class SourcesController < ApplicationController
  caches_page :sources, :show
  def show
    @source = DataModel::Source.where('source_db_name ILIKE ?', params[:source_db_name]).first
    !@source.blank? || not_found("This source doesn't exist in our system!")
    @title = @source.source_db_name
  end

  def sources
    @help_active = 'active'
    @sources = DataModel::Source.all
  end

end
