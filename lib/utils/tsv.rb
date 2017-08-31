module Utils
  module TSV
    def self.generate_interactions_tsv(filename = File.join(Rails.root, 'data/interactions.tsv'))
      write_tsv_file_for_query(filename, DataModel::InteractionClaim.for_tsv, 'interaction')
    end

    def self.generate_genes_tsv(filename = File.join(Rails.root, 'data', 'genes.tsv'))
      write_tsv_file_for_query(filename, DataModel::GeneClaim.for_tsv, 'gene')
    end

    def self.generate_drugs_tsv(filename = File.join(Rails.root, 'data', 'drugs.tsv'))
      write_tsv_file_for_query(filename, DataModel::DrugClaim.for_tsv, 'drug')
    end

    def self.generate_categories_tsv(filename = File.join(Rails.root, 'data/categories.tsv'))
      write_tsv_file_for_query(filename, DataModel::Gene.for_gene_categories, 'category')
    end

    def self.update_druggable_gene_tsvs_archive(filename = Rails.root.join('data', 'druggable_gene_tsvs.tar.gz'))
      old_dir = Dir.pwd
      Dir.chdir(filename.parent)
      system("tar -xvzf #{filename.basename}")
      Dir.chdir(filename.basename('.tar.gz'))

      copy_tsv_explicit('Entrez', 'GENES',
                        Genome::Updaters::GetEntrez.new.local_path('gene_info.human'))

      # Add stuff to tar
      ['CIViC', 'DoCM', 'Drug_Bank'].each do |source|
        copy_tsv(source, 'INTERACTIONS')
      end

      copy_tsv('GO', 'TARGETS')

      Dir.chdir(filename.parent)
      system("tar -czf #{filename} #{filename.basename('.tar.gz')}") && FileUtils.rmtree(filename.basename('.tar.gz'))
      Dir.chdir(old_dir)
    end

    private
    def self.write_tsv_file_for_query(filename, query, type)
      Logging.without_sql do
        File.open(filename, 'w') do |file|
          self.send("print_#{type}_header".to_sym, file)
          query.find_each do |obj|
            self.send("print_#{type}_row".to_sym, file, obj)
          end
        end
      end
    end

    def self.copy_tsv(source_name, type)
      klass = "Genome::Updaters::Get#{source_name.downcase.classify}".constantize
      obj = klass.new
      origin = obj.default_savefile
      copy_tsv_explicit(source_name, type, origin)
    end

    def self.copy_tsv_explicit(source_name, type, origin_path)
      path = Dir.pwd
      dest = Pathname(File.join(path, "#{source_name.gsub('_','')}_#{type}.tsv"))
      FileUtils::cp(origin_path, dest)
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
              .select do |gc|
                gc.gene_claim_categories.map(&:name).include?(category_name) &&
                !(license_restricted? gc.source.source_db_name)
              end
              .map { |gc| gc.source.source_db_name }.join(','),
            category_name,
          ].join("\t")
          file_handle.puts(row)
      end
    end

    def self.print_interaction_header(file_handle)
      header = ['gene_name','gene_claim_name','entrez_id','interaction_claim_source',
        'interaction_types','drug_claim_name','drug_claim_primary_name','drug_name','drug_chembl_id'].join("\t")
      file_handle.puts(header)
    end

    def self.print_interaction_row(file_handle, interaction_claim)
      return if license_restricted? interaction_claim.source.source_db_name
      row = [
        interaction_claim.gene ? interaction_claim.gene.name : "",
        interaction_claim.gene_claim.name,
        interaction_claim.gene ? interaction_claim.gene.entrez_id : "",
        interaction_claim.source.source_db_name,
        interaction_claim.interaction_claim_types.map(&:type).join(','),
        interaction_claim.drug_claim.name,
        interaction_claim.drug_claim.primary_name,
        interaction_claim.drug ? interaction_claim.drug.name : "",
        interaction_claim.drug ? interaction_claim.drug.chembl_id : "",
      ].join("\t")

      file_handle.puts(row)
    end

    def self.print_gene_header(file_handle)
      header = ['gene_claim_name','gene_name','entrez_id','gene_claim_source'].join("\t")
      file_handle.puts(header)
    end

    def self.print_gene_row(file_handle, gene_claim)
      gene_name = gene_claim.gene ? gene_claim.gene.name : ""
      entrez_id = gene_claim.gene ? gene_claim.gene.entrez_id : ""
      return if license_restricted? gene_claim.source.source_db_name
      row = [
        gene_claim.name,
        gene_name,
        entrez_id,
        gene_claim.source.source_db_name,
      ].join("\t")

      file_handle.puts(row)
    end

    def self.print_drug_header(file_handle)
      header = ['drug_claim_name','drug_name','chembl_id','drug_claim_source'].join("\t")
      file_handle.puts(header)
    end

    def self.print_drug_row(file_handle, drug_claim)
      drug_name = drug_claim.drug ? drug_claim.drug.name : ""
      chembl_id = drug_claim.drug ? drug_claim.drug.chembl_id : ""
      return if license_restricted? drug_claim.source.source_db_name
      row = [
        drug_claim.name,
        drug_name,
        chembl_id,
        drug_claim.source.source_db_name,
      ].join("\t")

      file_handle.puts(row)
    end

    private
    def self.license_restricted
      @@license_restricted ||= %w[PharmGKB DrugBank]
    end

    def self.license_restricted? (source_name)
      return license_restricted.member? source_name
    end
  end
end

