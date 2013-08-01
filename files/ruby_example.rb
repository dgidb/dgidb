require 'json'
require 'net/http'
require 'uri'

class DgidbApiClient

  def initialize(host = 'http://dgidb.genome.wustl.edu', port = 80, api_version = '/api/v1/')
    @connection_uri = URI(host).tap do |uri|
      uri.port = port
    end
    endpoints.each do |endpoint_name, (_, endpoint_path)|
      endpoints[endpoint_name][1] = uri_for_endpoint(host, port, api_version, endpoint_path)
    end
  end

  def connect
    if block_given?
      Net::HTTP.start(@connection_uri.hostname, @connection_uri.port) do |http|
        yield http
      end
    else
      Net::HTTP.new(@connection_uri.hostname, @connection_uri.port)
    end
  end

  def query(endpoint, connection = nil, opts = {})
    if connection.is_a? Hash
      opts = connection
      connection = nil
    end
    given_connection = !!connection
    connection ||= connect.start

    request = prepare_request(*endpoints[endpoint], opts)
    response = connection.request(request)
    connection.finish unless given_connection
    process_response(response)
  end

  def available_endpoints
    endpoints.keys
  end

  private
  def uri_for_endpoint(host, port, api_version, endpoint)
    URI.join(host, api_version, endpoint).tap do |uri|
      uri.port = port
    end
  end

  def prepare_request(request_type, uri, opts)
    request_type.new(uri).tap do |req|
      req.set_form_data(opts)
    end
  end

  def process_response(res)
    case res
    when Net::HTTPSuccess then
      JSON.parse(res.body)
    else
      raise "Request failed with code #{res.code} and message #{res.body}!"
    end
  end

  def endpoints
    @endpoints ||= {
      interactions: [Net::HTTP::Post, 'interactions.json'],
      interaction_types: [Net::HTTP::Get, 'interaction_types.json'],
      interaction_sources: [Net::HTTP::Get, 'interaction_sources.json'],
      drug_types: [Net::HTTP::Get, 'drug_types.json'],
      gene_categories: [Net::HTTP::Get, 'gene_categories.json'],
      source_trust_levels: [Net::HTTP::Get, 'source_trust_levels.json'],
      related_genes: [Net::HTTP::Post, 'related_genes.json']
    }
  end

end

#Create a new API client
#if you are running your own dgidb locally, you can supply custom hostnames and ports
client = DgidbApiClient.new('http://localhost', 3000)

#get a list of endpoints that the client supports and print it out
endpoints = client.available_endpoints
puts endpoints

#get a list of source trust levels available for filtering and print it out
source_trust_levels = client.query(:source_trust_levels)
puts source_trust_levels

#Query for drug-gene interactions involving FLT3 or EGFR, but only from expert curated sources
query_params = { source_trust_levels: 'Expert curated', genes: 'FLT3,EGFR' }
interaction_results = client.query(:interactions, query_params)
puts interaction_results

#If you are making multiple requests, you can reuse the same http connection
client.connect do |http|
  puts client.query(:drug_types, http)
  puts client.query(:interaction_sources, http)
  puts client.query(:related_genes, http, { genes: 'MPL,JAKK2' })
end
