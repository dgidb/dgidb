module Genome
  module Importers
    module TSVImporter
      def self.import(tsv_path, rowtype, source_info, row_delimiter = "\t",  &block)
        @tsv_path = tsv_path
        @rowtype = rowtype
        DSL::Importer.new(source_info).tap do |instance|
          each_row(row_delimiter) do |row|
            instance.row = row
            instance.instance_eval(&block)
          end
        end
      end

      private
      def self.each_row(row_delimiter)
        File.open(@tsv_path).each_with_index do |line, index|
          next if index == 0
          row = @rowtype.new(line, row_delimiter)
          yield row if row.valid?
        end
      end
    end
  end
end