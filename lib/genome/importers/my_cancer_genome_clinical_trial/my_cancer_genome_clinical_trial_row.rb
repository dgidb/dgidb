require 'genome/importers/delimited_row'

module Genome
  module Importers
    module MyCancerGenomeClinicalTrial
      class MyCancerGenomeClinicalTrialRow < Genome::Importers::DelimitedRow
        attribute :disease
        attribute :my_cancer_genome_call
        attribute :molecular_target
        attribute :entrez_gene_name
        attribute :entrez_gene_id
        attribute :drug_name
        attribute :pubchem_name
        attribute :cid
        attribute :other_drug_names, Array, delimiter: ' '
        attribute :clinical_trial_id
        attribute :indication_of_interaction
        attribute :interaction_type

        def valid?(opts = {})
          pubchem_name.downcase =~ /n\/a/ ? false : true
        end
      end
    end
  end
end

