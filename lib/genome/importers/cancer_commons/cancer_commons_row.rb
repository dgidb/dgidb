require 'genome/importers/delimited_row'
module Genome
  module Importers
    module CancerCommons
      class CancerCommonsRow < Genome::Importers::DelimitedRow
        attribute :primary_gene_name
        attribute :entrez_gene_id
        attribute :reported_gene_names
        attribute :pubchem_drug_id
        attribute :pubchem_drug_name
        attribute :source_reported_drug_name
        attribute :drug_trade_name
        attribute :drug_development_name
        attribute :primary_drug_name
        attribute :drug_class
        attribute :interaction_type
        attribute :pharmaceutical_developer
        attribute :data_source
        attribute :cancer_type

        def
          valid?(opts = {})
          true
        end
      end
    end
  end
end

