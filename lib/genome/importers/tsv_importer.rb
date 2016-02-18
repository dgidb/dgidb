module Genome
  module Importers
    module TSVImporter
      def self.import(tsv_path, rowtype, source_info, header = true, row_delimiter = "\t",  &block)
        @tsv_path = tsv_path
        @rowtype = rowtype
        @header = header
        DSL::Importer.new(source_info).tap do |instance|
          each_row(row_delimiter) do |row|
            instance.row = row
            instance.instance_eval(&block)
          end
        end
      end

      private
      def self.each_row(row_delimiter)
        f = File.open(@tsv_path)
        if @tsv_path.to_s.ends_with?('.tsv.gz')
          f = Zlib::GzipReader(f)
        end
        f.each_with_index do |line, index|
          if index == 0 && @header
            puts "Skipping presumed header line in %s..." % [@tsv_path]
            next
          end
          next if line.blank?
          row = @rowtype.new(line, row_delimiter)
          yield row if row.valid?
        end
      end
    end
  end
end