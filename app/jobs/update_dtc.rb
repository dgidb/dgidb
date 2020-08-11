require 'open-uri'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class UpdateDtc < TsvUpdater
  def tempfile_name
    ['dtc_bioactivity', '.csv']
  end

  def importer
    Genome::Importers::Dtc::DtcImporter.new(tempfile)
  end

  def download_file
    uri = URI('https://drugtargetcommons.fimm.fi/static/Excell_files/DTC_data.csv')
    download = open(uri)
    IO.copy(download, tempfile_name)
  end
end
end
end

def should_group_genes?
  true
end

def should_group_drugs?
  true
end

def should_cleanup_gene_claims?
  false
end
end
