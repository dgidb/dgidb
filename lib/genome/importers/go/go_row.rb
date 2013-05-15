require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Go
      class GoRow < Genome::Importers::DelimitedRow
        attribute :go_id
        attribute :go_short_name
        attribute :human_readable_name
        attribute :go_term
        attribute :go_full_name
        attribute :go_description
        attribute :secondary_go_term
        attribute :go_name
        attribute :alternate_symbol_references

        def valid?(opts = {})
          true
        end
      end
    end
  end
end
