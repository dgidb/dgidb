require 'genome/importers/importer'
module Genome
  module Importers
    module TTD 
      class TTDImporter < Genome::Importers::Importer
        def initialize(ttd_tsv_path, source_db_version)
          @tsv_path          = ttd_tsv_path
          @source_db_version = source_db_version
          super()
        end

        private
        def rows
          File.open(@tsv_path).each_with_index do |line, index|
            next if index == 0
            row = TTDRow.new(line)
            yield row if row.valid?
          end
        end

        def process_file
          rows do |row|
            gene_claim = create_gene_claim_from_row(row)
            drug_claim = create_drug_claim_from_row(row)
            create_interaction_claim_from_row(row, gene_claim, drug_claim)
          end
        end

        def create_interaction_claim_from_row(row, gene_claim, drug_claim)
          interaction_claim = create_interaction_claim(drug_claim_id: drug_claim.id,
                                                       gene_claim_id: gene_claim.id,
                                                       known_action_type: 'unknown')
          create_interaction_claim_attributes(interaction_claim, row)
        end

        def create_interaction_claim_attributes(interaction_claim, row)
          row.interaction_types.each do |it|
            create_interaction_claim_attribute(name: 'Interaction Type',
                                               value: it,
                                               interaction_claim_id: interaction_claim.id)
          end
        end

        def create_drug_claim_from_row(row)
          drug_claim = create_drug_claim(name: row.drug_id,
                                         nomenclature: 'TTD Drug Id',
                                         primary_name: row.drug_name)
          create_drug_claim_aliases(drug_claim, row)
          create_drug_claim_attributes(drug_claim, row)
        end

        def create_drug_claim_aliases(drug_claim, row)
          create_drug_claim_alias(alias: row.drug_name,
                                  nomenclature: 'Primary Drug Name',
                                  drug_claim_id: drug_claim.id)
          create_drug_claim_alias(alias: row.drug_id,
                                  nomenclature: 'TTD Drug Id',
                                  drug_claim_id: drug_claim.id)
          row.drug_synonyms.reject{ |ds| ds == 'N/A'}.each do |synonym|
            create_drug_claim_alias(alias: synonym,
                                    nomenclature: 'Drug Synonym',
                                    drug_claim_id: drug_claim.id)
          end
          unless row.drug_cas_number == 'N/A'
            create_drug_claim_alias(alias: row.drug_cas_number,
                                    nomenclature: 'CAS Number',
                                    drug_claim_id: drug_claim.id)
          end
          unless row.drug_pubchem_cid == 'N/A'
            create_drug_claim_alias(alias: row.drug_pubchem_cid,
                                    nomenclature: 'Pubchem CId',
                                    drug_claim_id: drug_claim.id)
          end
          unless row.drug_pubchem_sid == 'N/A'
            create_drug_claim_alias(alias: row.drug_pubchem_sid,
                                    nomenclature: 'Pubchem SId',
                                    drug_claim_id: drug_claim.id)
          end
        end

        def create_gene_claim_from_row(row)
          gene_claim = create_gene_claim(name: row.gene_id,
                                         nomenclature: 'TTD Partner Id')
          create_gene_claim_aliases(gene_claim, row)
          gene_claim
        end

        def create_gene_claim_aliases(gene_claim, row)
          row.target_synonyms.each do |ts|
            unless ts == 'N/A'
              create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                      alias: ts,
                                      nomenclature: 'Gene Synonym')
            end
          end
          unless row.target_uniprot_id == 'N/A'
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.target_uniprot_id,
                                    nomenclature: 'Uniprot Accession')
          end
          unless row.target_entrez_id == 'N/A'
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.target_entrez_id,
                                    nomenclature: 'Entrez Gene Id')
          end
          unless row.target_ensembl_id == 'N/A'
            create_gene_claim_alias(gene_claim_id: gene_claim.id,
                                    alias: row.target_ensembl_id,
                                    nomenclature: 'Ensembl Gene Id')
          end

        end

        def create_source!
          DataModel::Source.new.tap do |s|
            s.id                = SecureRandom.uuid
            s.base_url          = 'http://bidd.nus.edu.sg/group/cjttd/ZFTTD'
            s.site_url          = 'http://bidd.nus.edu.sg/group/ttd/ttd.asp'
            s.citation          = "Update of TTD: Therapeutic Target Database. Zhu F, Han BC, ..., Zheng CJ, Chen YZ. Nucleic Acids Res. 38(suppl 1):D787-91, 2010. PMID: 19933260."
            s.source_db_version = @source_db_version
            s.source_type_id    = DataModel::SourceType.INTERACTION
            s.source_db_name    = 'TTD'
            s.full_name         = 'Therapeutic Target Database'
            s.save
          end
        end
      end
    end
  end
end
