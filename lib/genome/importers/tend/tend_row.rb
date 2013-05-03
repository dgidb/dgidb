require 'genome/importers/delimited_row'
module Genome
  module Importers
    module TEND
      class TENDRow < Genome::Importers::DelimitedRow
        attribute :interaction_id
        attribute :drug_name
        attribute :indication, Array, delimiter: ';'
        attribute :year_of_approval
        attribute :uniprot_id
        attribute :uniprot_accession_number
        attribute :entrez_id
        attribute :ensembl_id
        attribute :gene_symbol
        attribute :gene_description
        attribute :target_main_class, Array, delimiter: ';'
        attribute :target_subclass, Array, delimiter: ';'
        attribute :number_transmembrane_helices

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
