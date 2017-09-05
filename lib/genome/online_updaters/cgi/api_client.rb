require 'open-uri'
require 'zip'

module Genome; module OnlineUpdaters; module Go;
  class ApiClient
    def interactions_for_cgi(id)
      get_tsv(interaction_lookup_base_url(id))
    end

    def get_tsv(url)
      uri = URI.parse(url)
      body = make_get_request(uri)
      csv_rows = CSV.parse(body, :headers => ['alteration', 'alteration_type', 'assay_type', 'association','biomarker',
      'curator', 'drug', 'drug_family', 'drug_full_name', 'drug_status','evidence_label', 'gene', 'tumor_type',
      'primary_tumor_acronym', 'source', 'targeting', 'individual_mutation', 'transcript', 'gene', 'strand', 'region', 'info',
                                              'cDNA', 'gDNA', 'primary_tumor_type'], :col_sep => '\t')
    end

    def make_get_request(uri)
      res = Net::HTTP.get_response(uri)
      raise StandardError.new("Request Failed!") unless res.code == '200'
      res.body
    end

    def gene_lookup_base_url(id)
      'https://www.cancergenomeinterpreter.org/data/cgi_biomarkers_latest.zip'
    end
  end
end; end; end;