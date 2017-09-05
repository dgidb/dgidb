require('zip')

class UpdateCgi < TsvUpdater
  def tempfile_name
    ['cgi_biomarkers_per_variant', '.tsv']
  end

  def importer
    Genome::OnlineUpdaters::Cgi::NewCgi.new(tempfile)
  end

  def download_file

  end

  def next_update_time
    Date.today
      .beginning_of_week
      .next_month
      .midnight
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