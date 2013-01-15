require 'genome/importers/importer'
module Genome
  module Importers
    module HopkinsGroom
      class HopkinsGroomImporter < Genome::Importers::Importer
        def initialize(hg_tsv_path, source_db_version)
          @tsv_path          = hg_tsv_path
          @source_db_version = source_db_version
          super()
        end

        private
        def each_row
          File.open(@tsv_path).each_with_index do |line, index|
            next if index == 0
            row = HopkinsGroomRow.new(line)
            yield row if row.valid?
          end
        end

        def process_file
          each_row do |row|
            create_gene_claim_from_row(row)
          end
        end

        def create_gene_claim_from_row(row)
          gene_claim = create_gene_claim(name: row.uniprot_acc,
                                         nomenclature: 'HopkinsGroom Gene Name')
          create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_attributes_from_row(gene_claim, row)
        end

        def create_gene_claim_aliases_from_row(gene_claim, row)
          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.uniprot_acc.upcase,
                                  nomenclature: 'Uniprot Accession')

          create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                  alias: row.uniprot_id.upcase,
                                  nomenclature: 'Uniprot Id')

          unless(row.uniprot_protein_name.blank? || row.uniprot_protein_name.downcase == 'n/a')
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.uniprot_protein_name,
                                    nomenclature: 'Uniprot Protein Name')
          end

          unless(row.uniprot_gene_name.blank? || row.uniprot_gene_name.downcase == 'n/a')
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.uniprot_gene_name.upcase,
                                    nomenclature: 'Uniprot Gene Name')
          end

          unless(row.entrez_id.blank? || row.entrez_id.downcase == 'n/a')
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.entrez_id.upcase,
                                    nomenclature: 'Entrez Gene Id')
          end

          row.ensembl_id.each do |eid|
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: eid.gsub(' ', '').upcase,
                                    nomenclature: 'Ensembl Gene Id')
          end
        end

        def create_gene_claim_attributes_from_row(gene_claim, row)
          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Human Readable Name',
                                      value: 'DRUGGABLE GENOME')

          unless(row.dgidb_human_readable.blank? || row.dgidb_human_readable.downcase == 'n/a/')
            value = row.dgidb_human_readable.gsub('-',' ').gsub('/',' ').gsub('.','_').upcase
            create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                        name: 'Human Readable Name',
                                        value: value )
          end

          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Interpro Acc',
                                      value: row.interpro_acc)

          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Uniprot Evidence',
                                      value: row.uniprot_evidence)

          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Uniprot Status',
                                      value: row.uniprot_status)

          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Interpro Name',
                                      value: row.interpro_name)

          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Interpro Short Name',
                                      value: row.interpro_short_name)

          create_gene_claim_attribute(gene_claim_id: gene_claim.id,
                                      name: 'Interpro Type',
                                      value: row.interpro_type)
        end

        def create_source!
          DataModel::Source.new.tap do |s|
            s.id                = SecureRandom.uuid
            s.base_url          = 'http://www.uniprot.org/uniprot/'
            s.site_url          = 'http://www.ncbi.nlm.nih.gov/pubmed/12209152/',
            s.citation          = 'The druggable genome. Hopkins AL, Groom CR. Nat Rev Drug Discov. 2002 Sep;1(9):727-30. PMID: 12209152'
            s.source_db_version = @source_db_version
            s.source_type_id    = DataModel::SourceType.GENE
            s.source_db_name    = 'HopkinsGroom'
            s.full_name         = 'The druggable genome (Hopkins & Groom, 2002)'
            s.save
          end
        end
      end
    end
  end
end

