require 'open-uri'

module Genome
  module Downloaders
    class MyCancerGenome
      def self.download(save_path, download_path = 'http://www.mycancergenome.org/content/other/molecular-medicine/targeted-therapeutics')
        tables = download_and_parse(download_path)
        save_tsv(save_path, tables)
      end

      private
      def self.download_and_parse(path)
        doc = Nokogiri::HTML(open(path).read)
        doc.xpath('//table').map { |t| MyCancerGenomeTable.new(t) }
      end

      def self.save_tsv(save_path, tables)
        File.open(save_path, 'w:UTF-8') do |f|
          f.puts (tables[0].headers.push 'Category').join("\t")
          tables.each do |table|
            table.rows.each do |row|
              f.puts (row.push table.category_name).join("\t").gsub("\u200b", "")
            end
          end
        end
      end
    end

    class MyCancerGenomeTable
      def initialize(table)
        @table = table
      end

      def category_name
        @table.xpath('tbody/tr')
          .first
          .text
          .strip
      end

      def headers
        @table.xpath('tbody/tr')[1]
          .xpath('th').map { |header| header.text }
      end

      def rows
        parse_rows(@table.xpath('tbody/tr').drop(2))
      end

      private
      def parse_rows(rows)
        processed_rows = []
        gene_name = ''
        width = rows.first.xpath('td').count
        rows.each do |row|
          next if row.children.count == 0
          row_entry = row.xpath('td').map { |td| td.text.strip }
          if row_entry.size < width
            row_entry.unshift gene_name
          else
            gene_name = get_gene_name_from_row(row)
          end
          processed_rows << row_entry
        end
        processed_rows
      end

      def get_gene_name_from_row(row)
        row.xpath('td').first.text
      end
    end
  end
end