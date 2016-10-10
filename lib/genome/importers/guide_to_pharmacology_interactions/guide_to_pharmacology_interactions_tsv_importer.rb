include ActionView::Helpers::SanitizeHelper

module Genome
  module Importers
    module GuideToPharmacologyInteractions

      def self.source_info
        {
          base_url: 'http://www.guidetopharmacology.org/DATA/',
          site_url: 'http://www.guidetopharmacology.org/',
          citation: 'Pawson, Adam J., et al. "The IUPHAR/BPS Guide to PHARMACOLOGY: an expert-driven knowledgebase of drug targets and their ligands." Nucleic acids research 42.D1 (2014): D1098-D1106. PMID: 24234439.',
          source_db_version: '04-March-2015',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_db_name: 'GuideToPharmacologyInteractions',
          full_name: 'Guide to Pharmacology Interactions'
          #source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? || x == "''" || x == '""' }
        upcase = ->(x) {x.upcase}
        downcase = ->(x) {x.downcase}
        clean = ->(x) {strip_tags x.upcase}
        TSVImporter.import tsv_path, GuideToPharmacologyInteractionsRow, source_info do
          interaction known_action_type: 'unknown', transform: downcase do
            drug :ligand_id, nomenclature: 'GuideToPharmacology Ligand Identifier', primary_name: :ligand, transform: upcase do
              name :ligand_gene_symbol, nomenclature: 'Gene Symbol (for Endogenous Peptides)', unless: blank_filter
              name :ligand, nomenclature: 'GuideToPharmacology Ligand Name', transform: clean
              attribute :ligand_species, name: 'Name of the Ligand Species (if a Peptide)', unless: blank_filter
              name :ligand_pubchem_sid, nomenclature: 'PubChem Drug SID', unless: blank_filter
            end
            gene :target_id, nomenclature: 'GuideToPharmacology ID' do
              names :target_uniprot, nomenclature: 'UniProtKB ID', unless: blank_filter
              names :target_gene_symbol, nomenclature: 'Gene Symbol', unless: blank_filter
              name :target, nomenclature: 'GuideToPharmacology Name', unless: blank_filter
              # target_ligand fields are ignored for now.
            end
            attributes :pubmed_id, name: 'PMID', unless: blank_filter
            attribute :ligand_context, name: 'Interaction Context', unless: blank_filter
            attribute :receptor_site, name: 'Specific Binding Site for Interaction', unless: blank_filter
            attribute :assay_description, name: 'Details of the Assay for Interaction', unless: blank_filter
            attribute :action, name: 'Specific Action of the Ligand', unless: blank_filter
            attribute :action_comment, name: 'Details of Interaction', unless: blank_filter
            attribute :endogenous, name: 'Endogenous Drug?', unless: blank_filter
            attribute :primary_target, name: 'Direct Interaction?', unless: blank_filter
            attribute :type, name: 'Interaction Type'
            #attribute :concentration_range, name: 'Micromolar Concentration Range of Drug From Study', unless: blank_filter
            #the attributes for affinity + concentration are left out, due to the kludgy appearance they would have in this format.
          #binding.pry
	        end
        end.save!
      end
    end
  end
end
