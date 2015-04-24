require 'genome/importers/delimited_row'
module Genome
  module Importers
    module TdgClinicalTrial
      class TdgClinicalTrialRow < Genome::Importers::DelimitedRow
        attribute :index
        attribute :trial_name
        attribute :drug_name
        attribute :indication, Array, delimiter: ';'
        attribute :drug_class
        attribute :fda_approval # Labeled as "Year of Approval (FDA)". Most entries don't have a year.
        attribute :uniprot_id
        attribute :rask_gene  # Labeled as "gene symbol". Not HGNC gene symbols.
        attribute :gene_symbol  # Labeled as "gene". HGNC gene symbols.
        attribute :protein_name # This is some bungled nightmare of a field. Ignore it.
        attribute :target_main_class
        attribute :target_subclass, Array, delimiter: ';' # Labeled "Target class"
        attribute :target_novelty

        def valid?(opts = {})
          match_data = rask_gene.match(/HUMAN/)
          !match_data.nil?
        end
      end
    end
  end
end
