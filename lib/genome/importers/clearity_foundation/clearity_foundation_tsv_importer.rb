module Genome
  module Importers
    module ClearityFoundation

	def self.source_info
	 {
	   base_url: 'https://www.clearityfoundation.org/healthcare-pros/',
	   site_url: 'https://www.clearityfoundation.org/',
           citation: 'https://www.clearityfoundation.org/', 
	   source_db_version: '26-July-2013'
  	   source_type_id: DataModel::SourceType.INTERACTION,
	   source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
	   source_db_name: 'ClearityFoundation',
	   full_name: 'Clearity Foundation',
	 }
	end
	
	def self.run(tsv_path)
	  TSVImporter.import tsv_path, ClearityRow, source_info do
	    interaction known_action_type: 'unknown' do
	      gene :gene_name, nomenclature: 'Gene Target Symbol', transform: ->(x) { x.upcase } do 
		name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
		attribute :reported_gene_name, name: 'Clearity Reported Gene Name'		
		end

	      drug :drug_name, nomenclature: 'Primary Drug Name', primary_name: :drug_name do 
		attribute :drug_class, name: 'Drug Class'
		name :drug_trade_name, nomenclature: 'Drug Trade Name'
		name :pubchem_id, nomenclature: 'PubChem Drug ID' 
		attribute :drug_subclass, name: 'Drug Classification'
		attribute :linked_class_info, name: 'Link to Clearity Drug Class Schematic'
		end

		attribute :interaction_mechanism, name: 'Mechanism of Interaction' 	
		end
	      end.save!
	    end
	end
    end
end

