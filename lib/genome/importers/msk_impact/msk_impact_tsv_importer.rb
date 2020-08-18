module Genome
  module Importers
    module MskImpact

      def self.source_info
        {
            base_url: 'http://www.ncbi.nlm.nih.gov/pubmed/25801821',
            site_url: 'https://www.mskcc.org/msk-impact',
            citation: 'Memorial Sloan Kettering-Integrated Mutation Profiling of Actionable Cancer Targets (MSK-IMPACT): A Hybridization Capture-Based Next-Generation Sequencing Clinical Assay for Solid Tumor Molecular Oncology. Cheng, Donavan T., et al. The Journal of Molecular Diagnostics 17.3 (2015): 251-264. PMID: 25801821',
            source_db_version: 'May-2015',
            source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
            source_db_name: 'MskImpact',
            full_name: 'Memorial Sloan Kettering IMPACT',
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            license: 'Supplementary data from American Society for Investigative Pathology and the Association for Molecular Pathology copyright publication',
            license_link: 'https://jmd.amjpathol.org/action/showPdf?pii=S1525-1578%2815%2900045-8',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, MskImpactRow, source_info, header=false do
          gene :gene_symbol, nomenclature: 'Gene Symbol' do
            category 'CLINICALLY ACTIONABLE'
          end
        end.save!
      end
    end
  end
end
