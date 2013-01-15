require 'genome/importers/delimited_row'
module Genome
  module Importers
    module DGene
      class DGeneRow < Genome::Importers::DelimitedRow
        attribute :dgene_class
        attribute :dgene_short_name
        attribute :dgene_full_name
        attribute :human_readable_name
        attribute :dgene_id
        attribute :tax_id
        attribute :gene_id
        attribute :symbol
        attribute :locus_tag
        attribute :synonyms, Array, delimiter: '|'
        attribute :db_x_refs, Array, delimiter: '|'
        attribute :chromosome
        attribute :map_location
        attribute :description
        attribute :gene_type
        attribute :symbol_from_authority
        attribute :full_name
        attribute :nomenclature_status
        attribute :other_designations, Array, delimiter: '|'
        attribute :modification_date

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
