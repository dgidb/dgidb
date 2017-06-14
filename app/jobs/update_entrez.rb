require 'tempfile'
require 'open-uri'

#class UpdateEntrez < ActiveJob::Base
class UpdateEntrez
  attr_reader :entrez_file

  def perform(recurring = true)
    begin
      create_tempfile
      download_file
      import_entrez
    ensure
      remove_download
      #reschedule if recurring
    end
  end

  def create_tempfile
    @entrez_file = Tempfile.new(['entrez_download', '.gz'], File.join(Rails.root, 'tmp'))
  end

  def download_file
    download_stream = open(latest_entrez_path)
    IO.copy_stream(download_stream, entrez_file)
  end

  def import_entrez
    importer = Genome::Importers::Entrez::NewEntrez.new(entrez_file)
    importer.import
  end

  def remove_download
    entrez_file.close
    entrez_file.unlink
  end

  def reschedule
    self.class.set(wait_until: next_month).perform_later
  end

  def latest_entrez_path
    "ftp://ftp.ncbi.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz"
  end

  def next_month
    Date.today
      .beginning_of_week
      .next_month
      .midnight
  end
end