module PMID
  def self.make_get_request(url)
    retries = 0
    begin
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      raise StandardError.new(res.body) unless res.code == '200'
      res.body
    rescue
      if (retries += 1) <= 3
        sleep(retries)
        retry
      end
    end
  end
  def self.call_pubmed_api(pubmed_id)
    http_resp = PMID.make_get_request(PMID.url_for_pubmed_id(pubmed_id))
    PubMedResponse.new(http_resp, pubmed_id.to_s)
  end
  def self.get_citation_from_pubmed_id(pubmed_id)
    resp = PMID.call_pubmed_api(pubmed_id)
    resp.citation
  end

  def self.pubmed_url(pubmed_id)
    "https://www.ncbi.nlm.nih.gov/pubmed/#{pubmed_id}"
  end

  private
  def self.url_for_pubmed_id(pubmed_id)
    "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=#{pubmed_id}&retmode=json&tool=DGIdb&email=help@dgidb.org"
  end

  class PubMedResponse
    attr_reader :result
    def initialize(response_body, pmid)
      @result = JSON.parse(response_body)['result'][pmid]
    end

    def citation
      [first_author, year, article_title, journal].compact.join(', ')
    end

    def authors
      result['authors'].map{|a| a['name']}
    end

    def pmc_id
      result['articleids'].each do |articles|
        if articles['idtype'] == 'pmcid'
          return articles['value']
        end
      end
      return
    end

    def first_author
      if authors.size > 1
        authors.first + " et al."
      else
        authors.first
      end
    end

    def publication_date
      result['pubdate']
    end

    def year
      Date.parse(result['sortpubdate']).year
    end

    def journal
      result['source']
    end

    def full_journal_title
      result['fulljournalname']
    end

    def article_title
      result['title']
    end
  end
end
