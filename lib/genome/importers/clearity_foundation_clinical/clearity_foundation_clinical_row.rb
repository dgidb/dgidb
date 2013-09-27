require 'genome/importers/delimited_row'
module Genome
  module Importers
    module ClearityFoundation
      class ClearityClinicalRow < Genome::Importers::DelimitedRow
        attribute :molecular_target
        attribute :entrez_gene_name
        attribute :entrez_gene_id
        attribute :drug_name
        attribute :other_drug_name
        attribute :pubchem_name
        attribute :CID
        attribute :SID
        attribute :interaction_type
        attribute :mode_of_action
        attribute :clinical_trial_ID
        attribute :detail
        attribute :phase
        attribute :include
      end
    end
  end
end
