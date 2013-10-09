module Genome
  module Importers
    module FoundationOne

      def self.source_info
      {
        base_url: 'http://www.foundationone.com/help/current-gene-list.php',
        citation: 'insert-citation-here',
        site_url: 'http://www.foundationone.com/',
        source_db_version: '20-Sept-2013',
        source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
        source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
        source_db_name: 'FoundationOne',
        full_name: 'Foundation One',
      }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, FoundationOneRow, source_info do 
          gene :entrez_gene_name, nomenclature: 'Entrez Gene Name' do
            name :entrez_gene_id, nomenclature: "Entrez Gene ID"
            attribute :reported_gene_name, name: 'Source Reported Gene Name'
            attribute :gene_category, name: "Gene Category" 
          end
        end.save!
      end
    end
  end
end
