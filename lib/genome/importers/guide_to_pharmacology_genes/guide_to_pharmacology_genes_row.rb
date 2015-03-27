require 'genome/importers/delimited_row'
module Genome
  module Importers
    module GuideToPharmacologyGenes
      class GuideToPharmacologyGenesRow < Genome::Importers::DelimitedRow
        attribute :target_id
        attribute :target_name
        attribute :family_name
        attribute :family_id
        attribute :type
        attribute :hgnc_symbol
        attribute :hgnc_id
        attribute :hgnc_name
        attribute :human_nucleotide_refseq
        attribute :human_protein_refseq
        attribute :human_swissprot
        attribute :human_entrez_gene
        attribute :gene_category, Array, delimiter: '|'
        # attribute :gene_category
        
        def valid?(opts = {})
          tests = [human_entrez_gene.blank?, human_entrez_gene == '""', human_entrez_gene == "''"]
          tests.none?
        end
      end
    end
  end
end
