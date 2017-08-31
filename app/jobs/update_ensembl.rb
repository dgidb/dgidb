require "net/ftp"

class UpdateEnsembl < TsvUpdater
  def tempfile_name
    ['gene_txt.gz', '.gz']
  end

  def importer
    Genome::Importers::Ensembl::NewEnsembl.new(tempfile, latest_version)
  end

  def latest_version
    potential_version = 89
    until remote_exists?(path_for_version(potential_version)) || potential_version > 100
      potential_version += 1
    end
    return "#{potential_version}_38"
  end

  def latest_url
    potential_version = 89
    until remote_exists?(path_for_version(potential_version)) || potential_version > 100
      potential_version += 1
    end
    return uri_for_version(potential_version)
  end

  def path_for_version(version)
    "pub/current_gtf/homo_sapiens/Homo_sapiens.GRCh38.#{version}.gtf.gz"
  end

  def uri_for_version(version)
    "ftp://ftp.ensembl.org/pub/current_gtf/homo_sapiens/Homo_sapiens.GRCh38.#{version}.gtf.gz"
  end

  def remote_exists?(uri)
    ftp = Net::FTP.new("ftp.ensembl.org")
    ftp.login
    begin
      ftp.size(uri)
    rescue Net::FTPPermError
      return false
    end

    true
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
    false
  end

  def should_cleanup_gene_claims?
    true
  end
end
