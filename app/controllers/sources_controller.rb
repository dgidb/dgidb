class SourcesController < ApplicationController
  def show
    source = DataModel::Source.for_show
      .where('source_db_name ILIKE ?', params[:source_db_name]).first ||
        not_found("This source doesn't exist in our system!")
    @title = source.source_db_name
    @source = SourcePresenter.new(source, view_context)
  end

  def sources
    @help_active = 'active'
    @sources = DataModel::Source.for_show.all
      .map { |s| SourcePresenter.new(s, view_context) }
  end

end
