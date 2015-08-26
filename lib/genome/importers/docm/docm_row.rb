require 'genome/importers/delimited_row'
module Genome
  module Importers
    module Docm
      class DocmRow < Genome::Importers::DelimitedRow
        attribute :gene
        attribute :entrez_id
        attribute :drug, String, parser: ->(x) { x.upcase }
        attribute :effect
        attribute :pathway
        attribute :status
      end
    end
  end
end