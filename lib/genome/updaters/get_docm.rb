require 'net/http'

module Genome
  module Updaters
    class GetDocm
      def docm_url
        'http://docm.genome.wustl.edu/api/v1/variants.json'
      end

      def docm_params
        {'detailed_view' => true}
      end

      def docm_variants
        @docm_variants ||= JSON.parse(get_docm_variants)
      end

      def get_docm_variants
        uri = URI(docm_url)

        uri.query = URI.encode_www_form(docm_params)

        req = Net::HTTP::Get.new(uri)
        resp = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req)}
        if resp.code != '200'
          raise StandardError.new('Failed HTTP request')
        end

        resp.body
      end

      def process_drugs(drug_row)
        drug_row.split(/,|\+|plus/)
          .map(&:strip)
          .reject { |drug_name| drug_name =~ /inhib/ }
          .reject { |drug_name| drug_name =~ /HER3/ }
          .reject { |drug_name| drug_name =~ /TKI/ }
          .reject { |drug_name| drug_name =~ /anti/ }
          .reject { |drug_name| drug_name =~ /BRAF/ }
          .reject { |drug_name| drug_name =~ /radio/ }
          .reject { |drug_name| drug_name =~ /BH3/ }
          .map{|drug_name| drug_name.split(/\s+/).first}
      end

      def to_rows
        docm_variants.flat_map do |variant|
          if variant['drug_interactions'].present?
            variant['drug_interactions'].flat_map do |interaction|
              process_drugs(interaction['drug']).map do |drug|
                [
                    variant['gene'],
                    variant['entrez_id'],
                    drug,
                    interaction['effect'],
                    interaction['pathway'],
                    interaction['status']
                ]
              end
            end
          end
        end.compact.reject(&:blank?)
      end

      def headers
        ['gene', 'entrez_id', 'drug', 'effect', 'pathway', 'status']
      end

      def to_tsv(filename)
        File.open(filename, 'w') do |file|
          file.puts(headers.join("\t"))
          to_rows.each do |row|
            file.puts(row.join("\t"))
          end
        end
      end
    end
  end
end