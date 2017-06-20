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

  def next_update_time
    Date.today
      .beginning_of_week
      .next_month
      .midnight
  end

  def should_group_genes?
    return true
  end

  def should_group_drugs?
    return false
  end

  def should_cleanup_gene_claims?
    return true
  end
end
