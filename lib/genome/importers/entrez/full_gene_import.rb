module Importers; module Entrez
  class FullGeneImport
    attr_reader :file_path
    def initialize(file_path)
      @file_path = file_path
    end

    def import
      import_symbols
    end

    private
    def import_symbols
      ActiveRecord::Base.transaction do
        File.open(file_path, 'r') do |file|
          reader = Zlib::GzipReader.new(file, encoding: "iso-8859-1:UTF-8")
          CSV.new(reader, col_sep: "\t", headers: true).each do |line|
            next unless valid_line?(line)
            process_line(line)
          end
          reader.close
        end
      end
    end

    def valid_line?(line)
      line['GeneID'].present? &&
        line['Symbol_from_nomenclature_authority'].present? &&
        line['Symbol_from_nomenclature_authority'].strip != '-' &&
        line['#tax_id'] == '9606'
    end

    def process_line(line)
      gene = DataModel::Gene.where(entrez_id: line['GeneID'].to_i).first_or_initialize
      gene.name = line['Symbol_from_nomenclature_authority']
      gene.long_name = line['description']
      if gene.long_name.blank?
        gene.long_name = ''
      end
      gene.save
      if line['Synonyms'].present?
        line['Synonyms'].split('|').map do |synonym|
          if synonym.strip == '-'
            nil
          elsif (existing_alias = DataModel::GeneAlias.where('lower(alias) = ? and gene_id = ?', synonym.downcase, gene.id)).any?
            existing_alias.first
          else
            DataModel::GeneAlias.where('alias' => synonym, 'gene_id' => gene.id).first_or_create
          end
        end
        if (existing_alias = DataModel::GeneAlias.where('lower(alias) = ? and gene_id = ?', line['Symbol'].downcase, gene.id)).any?
          existing_alias.first
        else
          DataModel::GeneAlias.where('alias' => line['Symbol'], 'gene_id' => gene.id).first_or_create
        end
      end
    end
  end
end;end
