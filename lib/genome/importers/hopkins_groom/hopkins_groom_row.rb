require 'genome/importers/delimited_row'
module Genome
  module Importers
    module HopkinsGroom
      class HopkinsGroomRow < Genome::Importers::DelimitedRow
        attribute :relationship_id
        attribute :interpro_acc
        attribute :interpro_name
        attribute :interpro_short_name
        attribute :interpro_type
        attribute :dgidb_human_readable
        attribute :uniprot_acc
        attribute :uniprot_id
        attribute :uniprot_protein_name
        attribute :uniprot_gene_name
        attribute :uniprot_evidence
        attribute :uniprot_status
        attribute :entrez_id
        attribute :ensembl_id, Array, delimiter: ';'

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
