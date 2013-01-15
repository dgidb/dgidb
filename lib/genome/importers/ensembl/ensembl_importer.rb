require 'genome/importers/importer'
module Genome
  module Importers
    module Ensembl
      class EnsemblImporter < Genome::Importers::Importer
        def initialize(ensembl_tsv_path, source_db_version)
          @tsv_path          = ensembl_tsv_path
          @source_db_version = source_db_version
          super()
        end

        private
        def each_row
          File.open(@tsv_path).each_with_index do |line, index|
            next if index == 0
            row = EnsemblRow.new(line)
            yield row if row.valid?
          end
        end

        def process_file
          each_row do |row|
            create_gene_claim_from_row(row)
          end
        end

        def create_gene_claim_from_row(row)
          gene_claim = create_gene_claim(name: row.ensembl_id,
                                         nomenclature: 'Ensembl Gene Id')
          create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_attributes_from_row(gene_claim, row)
        end

        def create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.ensembl_id.upcase,
                                  nomenclature: 'Ensembl Gene Id')

          unless(row.ensembl_gene_symbol.downcase == 'n/a')
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.ensembl_gene_symbol.upcase,
                                    nomenclature: 'Ensembl Gene Name')
          end

        end

        def create_gene_claim_attributes_from_row(gene_claim, row)
          unless(row.ensembl_gene_biotype.downcase == 'n/a')
            create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                    value: row.ensembl_gene_biotype.upcase,
                                    name: 'Gene Biotype')
          end
        end

        def create_source!
          DataModel::Source.new.tap do |s|
            s.id                = SecureRandom.uuid
            s.base_url          = 'http://useast.ensembl.org/Homo_sapiens/Gene/Summary?g='
            s.site_url          = 'http://ensembl.org/index.html'
            s.citation          = 'Ensembl 2011. Flicek P, Amode MR, ..., Vogel J, Searle SM. Nucleic Acids Res. 2011 Jan;39(Database issue)800-6. Epub 2010 Nov 2. PMID: 21045057.'
            s.source_db_version = @source_db_version
            s.source_type_id    = DataModel::SourceType.GENE
            s.source_db_name    = 'Ensembl'
            s.full_name         = 'Ensembl'
            s.save
          end
        end
      end
    end
  end
end
