module Utils
  module TSV
    def self.generate_interactions_tsv(filename = 'interactions.tsv')
      write_tsv_file_for_query(filename, DataModel::Gene.for_search, 'interaction')
    end

    def self.generate_categories_tsv(filename = 'categories.tsv')
      write_tsv_file_for_query(filename, DataModel::Gene.for_gene_categories, 'category')
    end

    private
    def self.write_tsv_file_for_query(filename, query, type)
      Logging.without_sql do
        File.open(filename, 'w') do |file|
          self.send("print_#{type}_header".to_sym, file)
          query.find_each do |gene|
            self.send("print_#{type}_row".to_sym, file, gene)
          end
        end
      end
    end

    def self.print_category_header(file_handle)
      header = ['entrez_gene_symbol','gene_long_name',
        'category_sources','category'].join("\t")
      file_handle.puts(header)
    end

    def self.print_category_row(file_handle, gene)
      gene.gene_claims.flat_map(&:gene_claim_categories)
        .map(&:name).uniq.each do |category_name|
          row = [
            gene.name,
            gene.long_name,
            gene.gene_claims
              .select { |gc| gc.gene_claim_categories.map(&:name).include?(category_name) }
              .map { |gc| gc.source.source_db_name }.join(','),
            category_name,
          ].join("\t")
          file_handle.puts(row)
      end
    end

    def self.print_interaction_header(file_handle)
      header = ['entrez_gene_symbol','gene_long_name','interaction_claim_source',
        'interaction_types','drug_name','drug_primary_name'].join("\t")
      file_handle.puts(header)
    end

    def self.print_interaction_row(file_handle, gene)
      gene.gene_claims.flat_map(&:interaction_claims).each do |interaction|
        row = [
           gene.name,
           gene.long_name,
           interaction.source.source_db_name,
           interaction.interaction_claim_types.map(&:type).join(','),
           interaction.drug_claim.name,
           interaction.drug_claim.primary_name
        ].join("\t")

        file_handle.puts(row)
      end
    end
  end
end

