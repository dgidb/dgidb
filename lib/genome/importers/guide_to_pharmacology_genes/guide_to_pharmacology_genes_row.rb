require 'genome/importers/delimited_row'
module Genome
  module Importers
    module GuideToPharmacologyGenes
      class GuideToPharmacologyGenesRow < Genome::Importers::DelimitedRow
        attribute :type
        attribute :family_id
        attribute :family_name
        attribute :target_id
        attribute :target_name
        attribute :subunits
        attribute :target_systematic_name
        attribute :target_abbreviated_name
        attribute :synonyms, Array, delimiter: '|'
        attribute :hgnc_id
        attribute :hgnc_symbol
        attribute :hgnc_name
        attribute :human_genetic_localisation
        attribute :human_nucleotide_refseq
        attribute :human_protein_refseq
        attribute :human_swissprot
        attribute :human_entrez_gene
        attribute :rgd_id
        attribute :rgd_symbol
        attribute :rgd_name
        attribute :rat_genetic_localisation
        attribute :rat_nucleotide_refseq
        attribute :rat_protein_refseq
        attribute :rat_swissprot
        attribute :rat_entrez_gene
        attribute :mgi_id
        attribute :mgi_symbol
        attribute :mgi_name
        attribute :mouse_genetic_localisation
        attribute :mouse_nucleotide_refseq
        attribute :mouse_protein_refseq
        attribute :mouse_swissprot
        attribute :mouse_entrez_gene
        
        def valid?(opts = {})
          tests = [human_entrez_gene.blank?, human_entrez_gene == '""', human_entrez_gene == "''"]
          tests.none?
        end
      end
    end
  end
end
