require 'open-uri'

module Genome; module OnlineUpdaters; module Go;
  class ApiClient
    def genes_for_go_id(id)
      get_tsv(gene_lookup_base_url(id))
    end

    def get_tsv(url)
      uri = URI.parse(url)
      body = make_get_request(uri)
      csv_rows = CSV.parse(body, :headers => ['gene_name', 'id', 'nomenclature', 'synonyms'], :col_sep => "\t")
    end

    def make_get_request(uri)
      res = Net::HTTP.get_response(uri)
      raise StandardError.new("Request Failed!") unless res.code == '200'
      res.body
    end

    def gene_lookup_base_url(id)
      "http://golr.geneontology.org/select?defType=edismax&qt=standard&indent=on&wt=csv&rows=100000&start=0&fl=bioentity_label,bioentity,source,synonym&facet=true&facet.mincount=1&facet.sort=count&json.nl=arrarr&facet.limit=25&hl=true&hl.simple.pre=%3Cem%20class=%22hilite%22%3E&csv.encapsulator=&csv.separator=%09&csv.header=false&csv.mv.separator=%7C&fq=document_category:%22bioentity%22&fq=taxon_subset_closure_label:%22Homo%20sapiens%22&facet.field=source&facet.field=taxon_subset_closure_label&facet.field=type&facet.field=panther_family_label&facet.field=annotation_class_list_label&facet.field=regulates_closure_label&q=GO:#{id}&qf=bioentity%5E2&qf=bioentity_label_searchable%5E2&qf=bioentity_name_searchable%5E1&qf=bioentity_internal_id%5E1&qf=synonym%5E1&qf=isa_partof_closure_label_searchable%5E1&qf=regulates_closure%5E1&qf=regulates_closure_label_searchable%5E1&qf=panther_family_searchable%5E1&qf=panther_family_label_searchable%5E1&qf=taxon_label_searchable%5E1"
    end
  end
end; end; end;
