require 'genome/importers/importer'
module Genome
  module Importers
    module DGene
      class DGeneImporter < Genome::Importers::Importer
        def initialize(d_gene_tsv_path, source_db_version)
          @tsv_path          = d_gene_tsv_path
          @source_db_version = source_db_version
          super()
        end

        private
        def each_row
          File.open(@tsv_path).each_with_index do |line, index|
            next if index == 0
            row = DGeneRow.new(line)
            yield row if row.valid?
          end
        end

        def process_file
          each_row do |row|
            create_gene_claim_from_row(row)
          end
        end

        def create_gene_claim_from_row(row)
          gene_claim = create_gene_claim(name: row.gene_id,
                                         nomenclature: 'dGene Gene Id')
          create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_attributes_from_row(gene_claim, row)
        end

        def create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.symbol.upcase,
                                  nomenclature: 'Gene Symbol')

          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.gene_id.upcase,
                                  nomenclature: 'Entrez Gene Id')
        end

        def create_gene_claim_attributes_from_row(gene_claim, row)
          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Human Readable Name',
                                      value: row.human_readable_name.gsub('-',' ').upcase)
        end

        def create_source!
          DataModel::Source.new.tap do |s|
            s.id                = SecureRandom.uuid
            s.base_url          = 'http://www.ncbi.nlm.nih.gov/gene?term='
            s.site_url          = 'http://hematology.wustl.edu/faculty/Bose/BoseBio.html'
            s.citation          = 'The Druggable Gene List, dGENE, provides a Rapid Filter for Cancer Genome Sequencing Data. Kumar R, Chang L, Ellis MJ, Bose R. Manuscript in preparation.'
            s.source_db_version = @source_db_version
            s.source_type_id    = DataModel::SourceType.GENE
            s.source_db_name    = 'dGene'
            s.full_name         = 'dGENE - The Druggable Gene List'
            s.save
          end
        end
      end
    end
  end
end
