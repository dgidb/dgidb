require 'tempfile'
require 'open-uri'

class TsvUpdater < Updater
  attr_reader :tempfile
  attr_reader :tempfile_name
  attr_reader :latest_url
  attr_reader :importer

  def perform(recurring = true)
    begin
      create_tempfile
      download_file
      importer.import
    ensure
      remove_download
      reschedule if recurring
    end
  end

  def create_tempfile
    @tempfile = Tempfile.new(tempfile_name, File.join(Rails.root, 'tmp'))
  end

  def download_file
    download_stream = open(latest_url)
    IO.copy_stream(download_stream, tempfile)
  end

  def remove_download
    tempfile.close
    tempfile.unlink
  end

end
