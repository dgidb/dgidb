module Genome
  module Importers
    module GuideToPharmacologyGenes
      
      def self.source_info
        {
          base_url: 'http://www.guidetopharmacology.org/DATA/',
          site_url: 'http://www.guidetopharmacology.org/',
          citation: 'Pawson, Adam J., et al. "The IUPHAR/BPS Guide to PHARMACOLOGY: an expert-driven knowledgebase of drug targets and their ligands." Nucleic acids research 42.D1 (2014): D1098-D1106. PMID: 24234439.',
          source_db_version: '4-Mar-2015',
          source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_db_name: 'GuideToPharmacologyGenes',
          full_name: 'Guide to Pharmacology Genes',
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED
        }
      end
      
      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? || x == "''" || x == '""' }
        TSVImporter.import tsv_path, GuideToPharmacologyGenesRow, source_info do
          gene :target_id, nomenclature: 'GuideToPharmacology ID' do
            name :hgnc_name, nomenclature: 'HUGO Gene Name', unless: blank_filter
            name :hgnc_id, nomenclature: 'HUGO Gene ID', unless: blank_filter
            name :hgnc_symbol, nomenclature: 'Gene Symbol', unless: blank_filter
            name :target_name, nomenclature: 'GuideToPharmacology Name'
            attribute :family_name, name: 'GuideToPharmacology Gene Category Name'
            attribute :family_id, name: 'GuideToPharmacology Gene Category ID'
            attribute :type, name: 'GuideToPharmacology Gene Type'
            #attributes :gene_category, name: 'Gene Category'
            categories :gene_category
            name :human_nucleotide_refseq, nomenclature: 'RefSeq Nucleotide Accession', unless: blank_filter
            name :human_protein_refseq, nomenclature: 'RefSeq Protein Accession', unless: blank_filter
            name :human_swissprot, nomenclature: 'SwissProt Accession', unless: blank_filter
            name :human_entrez_gene, nomenclature: 'Entrez Gene ID', unless: blank_filter
          end
        end.save!
      end
    end
  end
end