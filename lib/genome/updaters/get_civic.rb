require 'net/http'

module Genome
  module Updaters
    class GetCivic
      def civic_url
        'https://civic.genome.wustl.edu/'
      end

      def civic_genes_params
        {'count' => 100000}
      end

      def civic_genes
        @civic_genes ||= JSON.parse(get_civic_genes)
      end

      def civic_interactions
        @civic_interactions ||= get_civic_interactions
      end

      def civic_connection
        @uri = URI(civic_url)
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = TRUE
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.read_timeout = 360
        @http = http
      end

      def get_civic_genes
        @http ||= civic_connection
        @uri.path = '/api/genes'
        @uri.query = URI.encode_www_form(civic_genes_params)
        req = Net::HTTP::Get.new(@uri.to_s)
        resp = @http.request(req)
        if resp.code != '200'
          raise StandardError.new('Failed HTTP request')
        end

        resp.body
      end

      def get_civic_interactions
        @http ||= civic_connection
        pmids = Hash.new { |h, k| h[k] = [] }
        civic_genes.flat_map do |gene|
          gene_id = gene['id']
          gene_name = gene['name']
          entrez_id = gene['entrez_id']
          gene['variants'].flat_map do |variant|
            variant_id = variant['id']
            @uri.path = '/' + ['api', 'variants', variant_id.to_s, 'evidence_items'].join('/')
            req = Net::HTTP::Get.new(@uri.to_s)
            resp = @http.request(req)
            if resp.code != '200'
              raise StandardError.new('Failed HTTP request')
            end
            evidence = JSON.parse(resp.body)
            evidence.flat_map do |item|
              if !item.has_key?("evidence_type")
                next
              end
              if item['evidence_type'] == 'Predictive' and item['evidence_direction'] == 'Supports' \
              and item['evidence_level'] != 'E' and item['rating'] and item['rating'] > 2
                item['drugs'].flat_map do |drug|
                  if drug['name'].upcase == 'N/A' or drug['name'].include?(';')
                    next
                  end
                  key = [gene_id, gene_name, drug['name'], entrez_id, "N/A"]
                  pmids[key] << item['pubmed_id']
                end
              end
            end
          end
        end
        interactions = []
        pmids.each do |k, v|
          interactions << k + [v.join(',')]
        end
        interactions
      end

      def headers
        ['civic_ids', 'gene_symbol', 'drug_names', 'entrez_gene_id', 'interaction_type', 'pmids']
      end

      def default_savefile
        [Rails.root.to_s, 'lib', 'genome', 'updaters', 'data', 'civic_interactions.tsv'].join('/')
      end

      def to_tsv(filename = nil)
        if filename.nil?
          filename = default_savefile
        end
        File.open(filename, 'w') do |file|
          file.puts(headers.join("\t"))
          civic_interactions.each do |row|
            file.puts(row.join("\t"))
          end
        end
      end

      def current_version
        DataModel::Source.where(source_db_name: 'CIViC').first['source_db_version']
      end

      def new_version
        Date.today.strftime("%d-%B-%Y")
      end

      def is_current?
        current_version == new_version
      end
    end
  end
end