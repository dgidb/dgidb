require 'genome/importers/delimited_row'
module Genome
  module Importers
    module ClearityFoundation
      class ClearityFoundationRow < Genome::Importers::DelimitedRow
	attribute :gene_name
	attribute :entrez_gene_id
	attribute :interaction_mechanism
	attribute :reported_gene_name
	attribute :drug_name
	attribute :drug_trade_name
	attribute :pubchem_id
	attribute :drug_class
	attribute :drug_subclass
	attribute :linked_class_info

	def
	  valid?(opts ={})
	  true
	end
      end
    end
  end
end
