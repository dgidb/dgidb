require 'tempfile'
require 'open-uri'

#class Updater  < ActiveJob::Base
class Updater
  attr_reader :tempfile
  attr_reader :tempfile_name
  attr_reader :importer
  attr_reader :latest_url

  def perform(recurring = true)
    begin
      create_tempfile
      download_file
      import
    ensure
      remove_download
      #reschedule if recurring
    end
  end

  def create_tempfile
    @tempfile = Tempfile.new(tempfile_name, File.join(Rails.root, 'tmp'))
  end

  def download_file
    download_stream = open(latest_url)
    IO.copy_stream(download_stream, tempfile)
  end

  def import
    importer.import
  end

  def remove_download
    tempfile.close
    tempfile.unlink
  end

  def reschedule
    self.class.set(wait_until: next_month).perform_later
  end

  def next_month
    Date.today
      .beginning_of_week
      .next_month
      .midnight
  end
end
