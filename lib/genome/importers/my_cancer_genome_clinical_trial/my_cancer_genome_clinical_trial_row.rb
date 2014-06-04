require 'genome/importers/delimited_row'

module Genome
  module Importers
    module MyCancerGenomeClinical
      class MyCancerGenomeClinicalRow < Genome::Importers::DelimitedRow
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
      end
    end
  end
end

