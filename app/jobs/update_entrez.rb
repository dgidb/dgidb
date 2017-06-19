class UpdateEntrez < TsvUpdater
  def tempfile_name
    return ['entrez_download', '.gz']
  end

  def importer
    return Genome::Importers::Entrez::NewEntrez.new(tempfile)
  end

  def latest_url
    "ftp://ftp.ncbi.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz"
  end
end
