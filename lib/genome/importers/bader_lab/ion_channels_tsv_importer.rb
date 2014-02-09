module Genome
	module Importers
		module BaderLab
	
	def self.source_info
	{
		base_url: '',
		citation: '',
		site_url: '',
		source_db_version: '',
		source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
		source_trust_level_id:DataModel::SourceTrustLevel.EXPERT_CURATED, 
		source_db_name: 'BaderLabGenes',
		full_name: 'Bader Lab Genes',
	}	end
	
	def self.run(tsv_path)
		TSVImporter.import tsv_path, BaderLabGenesRow, source_info do
			gene :primary_name, nomenclature: 'Entrez Gene Name' do
				name :entrez_gene_id, nomenclature: "Entrez Gene ID"
				attribute :initial_gene_query, name: 'Initial Gene Query'
				attribute :citations, name: 'Counted Citations from 1950-2000'				
				attribute :gene_category, name: 'Gene Category'
					end
				end.save!
			end
		end
	end 
end		
