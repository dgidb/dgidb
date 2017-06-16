require 'genome/importers/delimited_row'
module Genome
	module Importers
		module Talc
			class TalcRow < Genome::Importers::DelimitedRow
				attribute :drug_name
				attribute :gene_target
				attribute :interaction_type
				attribute :drug_generic_name
				attribute :drug_trade_name, Array, delimiter: ','
				attribute :drug_synonym, Array, delimiter: ','
				attribute :metadata

				def valid?(opts = {})
			        true
				end
			end
		end
	end
end

