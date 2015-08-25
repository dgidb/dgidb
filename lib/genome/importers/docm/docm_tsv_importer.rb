module Genome
  module Importers
    module Docm

      def self.source_info
        {
            base_url: 'http://docm.genome.wustl.edu/',
            citation: 'Manuscript in preparation. Please cite http://docm.genome.wustl.edu/',
            source_db_version: '25-Aug-2015',
            source_type_id: DataModel::SourceType.INTERACTION,
            source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
            source_db_name: 'DoCM',
            full_name: 'Database of Curated Mutations'
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, DocmRow, source_info do
          interaction
        end
      end

    end
  end
end