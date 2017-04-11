module PMID
  def self.make_get_request(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    raise StandardError.new(res.body) unless res.code == '200'
    res.body
  end
  def self.call_pubmed_api(pubmed_id)
    http_resp = PMID.make_get_request(PMID.url_for_pubmed_id(pubmed_id))
    PubMedResponse.new(http_resp)
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
    "https://www.ncbi.nlm.nih.gov/pubmed/#{pubmed_id}?report=xml&format=text"
  end

  class PubMedResponse
    attr_reader :xml
    def initialize(response_body)
      @xml = Nokogiri::XML(Nokogiri::XML(response_body).text)
    end

    def citation
      [first_author, year, article_title, journal].compact.join(', ')
    end

    def authors
      xml.xpath('//AuthorList/Author').to_a.each.with_index(1).map do |author, i|
        {
          fore_name: author.xpath('ForeName').text,
          last_name: author.xpath('LastName').text,
          author_position: i
        }
      end
    end

    def pmc_id
      xpath_contents_or_nil("//PubmedData/ArticleIdList/ArticleId[@IdType='pmc']")
    end

    def abstract
      xpath_contents_or_nil('//Abstract/AbstractText')
    end

    def first_author
      xpath_contents_or_nil('//AuthorList/Author[1]/LastName') do |author_name|
        if xml.xpath('//AuthorList/Author').size > 1
          author_name + " et al."
        else
          author_name
        end
      end
    end

    def publication_date
     [day, month, year]
    end

    def year
      xpath_contents_or_nil('//Journal/JournalIssue/PubDate/Year')
    end

    def month
      monthname = xpath_contents_or_nil('//Journal/JournalIssue/PubDate/Month')
      if monthname
        Date::ABBR_MONTHNAMES.index(monthname)
      else
        nil
      end
    end

    def day
      xpath_contents_or_nil('//Journal/JournalIssue/PubDate/Day')
    end

    def journal
      xpath_contents_or_nil('//Journal/ISOAbbreviation')
    end

    def full_journal_title
      xpath_contents_or_nil('//Journal/Title')
    end

    def article_title
      xpath_contents_or_nil('//Article/ArticleTitle')
    end

    private
    def xpath_contents_or_nil(path)
      if (node = xml.xpath(path).text).blank?
        nil
      elsif block_given?
        yield node
      else
        node
      end
    end
  end
end