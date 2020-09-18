module Genome
  module Importers
    module RussLampel
      def source_info
        {
          base_url:           'http://useast.ensembl.org/Homo_sapiens/Gene/Summary?g=',
          site_url:           'http://www.ncbi.nlm.nih.gov/pubmed/16376820/',
          citation:           'The druggable genome: an update. Russ AP, Lampel S. Drug Discov Today. 2005 Dec;10(23-24):1607-10. PMID: 16376820',
          source_db_version:  '26-Jul-2011',
          source_type_id:     DataModel::SourceType.GENE,
          source_db_name:     'RussLampel',
          full_name:          'The druggable genome: an update (Russ & Lampel, 2005)',
          license: 'Unknown; data is no longer publicly available from external site, referenced in Elsevier copyright publication',
          license_link: 'https://www.sciencedirect.com/science/article/pii/S1359644605036664',
        }
      end

      def self.run(tsv_path)
        na_filter = ->(x) { x.upcase == 'N/A' }
        TSVImporter.import tsv_path, RussLampelRow, source_info do
          gene :gene_stable_id, nomenclature: 'RussLampel Gene Stable Id' do
            #name :HumanReadableName, nomenclature :HumanReadableName #TODO: this needs an update to the dsl to allow the nomenclature to work
            name :gene_stable_id, nomenclature: 'Ensembl Gene Id', unless: na_filter
            name :display_id, nomenclature: 'Display Id', unless: na_filter
            name :description, nomenclature: 'Description', unless: na_filter
          end
        end
      end
    end
  end
end
