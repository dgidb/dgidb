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

  def self.call_pubmed_api(pubmed_ids)
    PMID.make_get_request(PMID.url_for_pubmed_ids(pubmed_ids.join(',')))
  end

  def self.get_citations_from_publications(publications)
    pmids = publications.map{|p| p.pmid.to_s}
    resp = PMID.call_pubmed_api(pmids)
    responses(resp, publications)
  end

  def self.pubmed_url(pubmed_id)
    "https://www.ncbi.nlm.nih.gov/pubmed/#{pubmed_id}"
  end

  private
  def self.url_for_pubmed_ids(pubmed_ids)
    "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=#{pubmed_ids}&retmode=json&tool=DGIdb&email=help@dgidb.org"
  end

  def self.responses(http_resp, publications)
    response_body = JSON.parse(http_resp)['result']
    publications.each_with_object({}) do | publication, h |
      h[publication] = PubMedResponse.new(response_body[publication.pmid.to_s]).citation
    end
  end

  class PubMedResponse
    attr_reader :result
    def initialize(result)
      @result = result
    end

    def citation
      if result.has_key? 'authors'
        [first_author, year, article_title, journal].compact.join(', ')
      else
        ""
      end
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
