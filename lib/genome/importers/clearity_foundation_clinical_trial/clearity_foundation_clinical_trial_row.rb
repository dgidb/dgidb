require 'genome/importers/delimited_row'
module Genome
  module Importers
    module ClearityFoundationClinicalTrial
      class ClearityFoundationClinicalTrialRow < Genome::Importers::DelimitedRow
        attribute :molecular_target
        attribute :entrez_gene_name
        attribute :entrez_gene_id
        attribute :drug_name
        attribute :other_drug_names, Array, delimiter: ','
        attribute :pubchem_name
        attribute :cid
        attribute :sid
        attribute :interaction_type
        attribute :mode_of_action
        attribute :clinical_trial_id
        attribute :detail
        attribute :phase
        attribute :include_this_entry
        attribute :comments

        def valid?(opts = {})
          include_this_entry == "1"
        end
      end
    end
  end
end
