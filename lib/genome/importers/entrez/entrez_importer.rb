require 'genome/importers/importer'
module Genome
  module Importers
    module Entrez
      class EntrezImporter < Genome::Importers::Importer
        def initialize(entrez_tsv_path, source_db_version)
          @tsv_path          = entrez_tsv_path
          @source_db_version = source_db_version
          super()
        end

        private
        def each_row
          File.open(@tsv_path).each_with_index do |line, index|
            next if index == 0
            row = EntrezRow.new(line)
            yield row if row.valid?
          end
        end

        def process_file
          each_row do |row|
            create_gene_claim_from_row(row)
          end
        end

        def create_gene_claim_from_row(row)
          gene_claim = create_gene_claim(name: row.entrez_id,
                                         nomenclature: 'Entrez Gene Id')
          create_gene_claim_aliases_from_row(gene_claim, row)
        end

        def create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.description,
                                  nomenclature: 'Gene Description')

          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.entrez_id.upcase,
                                  nomenclature: 'Entrez Gene Id')


          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.entrez_gene_symbol.upcase,
                                  nomenclature: 'Gene Symbol')

          row.entrez_gene_synonyms.each do |synonym|
            unless(synonym.blank? || synonym.downcase == 'n/a')
              create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                      alias: synonym.upcase,
                                      nomenclature: 'Gene Synonym')
            end
          end

          row.ensembl_ids.each do |id|
            unless(id.blank? || id.downcase == 'n/a')
              create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                      alias: id.upcase,
                                      nomenclature: 'Ensembl Gene Id')
            end
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
