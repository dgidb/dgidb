require('zip')

class UpdateCgi < TsvUpdater
  def tempfile_name
    ['cgi_biomarkers_per_variant', '.tsv']
  end

  def importer
    Genome::OnlineUpdaters::Cgi::NewCgi.new(tempfile)
  end

  def get_interactions
    get_zipfile(zip_url)
  end

  def zip_url
    'https://www.cancergenomeinterpreter.org/data/cgi_biomarkers_latest.zip'
  end

  def get_zipfile(url)
    uri = URI(url)

    uri.query = URI.encode_www_form(docm_params)

    req = Net::HTTP::Get.new(uri)
    resp = Net::HTTP.start(uri.host, uri.port) { |http| http.read_timeout = 1000; http.request(req)}
    if resp.code != '200'
      raise StandardError.new('Failed HTTP request')
    end

    resp.body
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