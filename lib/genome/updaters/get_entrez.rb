require 'net/ftp'
require 'csv'
require 'set'
module Genome
  module Updaters
    class GetEntrez
      def current_version
        DataModel::Source.where(source_db_name: 'Entrez').first['source_db_version']
      end

      def new_version
        @new_version ||= Date.today.strftime("%d-%B-%Y")
      end

      def is_current?
        current_version == new_version
      end

      def entrez_ftp_server
        'ftp.ncbi.nlm.nih.gov'
      end

      def gene2accession_path
        'gene/DATA/gene2accession.gz'
      end

      def gene_info_path
        'gene/DATA/gene_info.gz'
      end

      def interactions_path
        'gene/GeneRIF/interactions.gz'
      end

      def headers
        @headers ||= %w(entrez_id entez_gene_symbol entrez_gene_synonyms ensembl_ids description)
      end

      def to_tsv
        # entrez = Genome::Updaters::GetEntrez.new
        # f = open(entrez.local_path('gene_info.gz'))
        check_files
        f = File.open(local_path('gene_info.gz'))
        fields = %w(tax_id entrez_id entrez_gene_symbol locus_tag entrez_gene_synonyms dbXrefs chromosome map_loc
                    description type sym_from_auth full_from_auth nom_status other_designations mod_date)
        out_file = File.open(local_path('gene_info.human'), 'w')
        out_file.puts(headers.join("\t"))
        skipped = 0
        Zlib::GzipReader.new(f).each_with_index do |line, index|
          if index == 0
            skipped += 1
            next
          end
          if index % 1_000_000 == 0
            puts "processed #{index} lines (#{skipped} non-human genes skipped)..."
          end
          if !line.start_with?('9606')
            skipped += 1
            next
          end
          ensembl = Set.new
          begin
            a = CSV.parse_line(line, col_sep: "\t", quote_char:'!')
          rescue CSV::MalformedCSVError
            a = CSV.parse_line(line, col_sep: "\t", quote_char:'`')
          end
          a = a.map { |field| field.gsub('-', 'N/A')}
          h = Hash[fields.zip(a)]
          ## The below commented text is implied in the line.starts_with?('9606') check above.
          ## This assumes that the tax_id column will always be at front of file. Use this if
          ## those conditions are ambiguous in the future (much slower).
          # if h['tax_id'] != '9606'
          #   skipped += 1
          #   next
          # end
          h['dbXrefs'].split('|').each do |xRef|
            if xRef == 'N/A'
              next
            end
            source, label = xRef.split(':', 1)
            if source == 'Ensembl'
              ensembl.add(label)
            end
          end
          h['ensembl_ids'] = ensembl.empty? ? 'N/A' : ensembl.to_a.join('|')
          out = headers.map { |header| h[header] }.join("\t")
          out_file.puts(out)
        end
        out_file.close
      end

      def local_path(basename)
        [Rails.root, %w(lib genome updaters data), basename].flatten.join('/')
      end

      def check_files
        %w(gene2accession.gz gene_info.gz interactions.gz).each do |file_name|
          file_path = local_path(file_name)
          if File.exist?(file_path) && File.mtime(file_path).to_date == Date.today
            next
          end
          puts "downloading Entrez files from #{entrez_ftp_server}..."
          download_files
          return
        end
        puts "files up-to-date."
        return
      end

      def download_files
        Net::FTP.open(entrez_ftp_server) do |ftp|
          ftp.passive = true
          ftp.login
          ftp.getbinaryfile(gene2accession_path, local_path('gene2accession.gz'))
          ftp.getbinaryfile(gene_info_path, local_path('gene_info.gz'))
          ftp.getbinaryfile(interactions_path, local_path('interactions.gz'))
        end
      end

    end
  end
end
