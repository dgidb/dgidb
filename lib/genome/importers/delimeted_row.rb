module Genome
  module Importers
    class DelimetedRow
      def initialize(row, row_delimeter = "\t")
        @row = row.split(row_delimeter)
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

      def self.attribute(name, type = String, opts = {delimeter: ','})
        unless type == String || type == Array
          raise 'Sorry, only string and array types are supported'
        end

        (@attributes ||=  {})[name] = self.send("#{type.to_s.downcase}_parser")
        attr_accessor name
      end

      def self.string_parser(opts = {})
        ->(item) { item.strip }
      end

      def self.array_parser(opts = {})
        ->(item) { item.split(opts[:delimeter]).map {|item| item.strip } }
      end
    end
  end
end