module Genome
  module Importers
    class DelimitedRow
      def initialize(row, row_delimiter = "\t")
        @row = row.split(row_delimiter, -1)
        if @row.size != self.class.attributes.keys.size
          raise 'Given row does not match specified attributes'
        end
        parse_row
      end

      def valid?(opts = {})
        true
      end

      def self.attributes
        @attributes
      end

      private
      def parse_row
        self.class.attributes.keys.each_with_index do |attr, index|
          val = self.class.attributes[attr].call(@row[index])
          self.send("#{attr}=", val)
        end
      end

      def self.attribute(name, type = String, opts = {})
        unless type == String || type == Array
          raise 'Sorry, only string and array types are supported'
        end

        opts = {delimiter: ','}.merge(opts)

        (@attributes ||= {})[name] = if opts[:parser]
          opts[:parser]
        else
          self.send("#{type.to_s.downcase}_parser", opts)
        end
        attr_accessor name
      end

      def self.string_parser(opts = {})
        ->(item) { item.strip }
      end

      def self.array_parser(opts = {})
        ->(item) { item.split(opts[:delimiter]).map(&:strip) }
      end
    end
  end
end