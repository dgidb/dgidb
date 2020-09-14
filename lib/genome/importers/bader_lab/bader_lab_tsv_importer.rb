module Genome
  module Importers
    module BaderLab

      def self.source_info
        {
          base_url: 'http://baderlab.org/Data/RoadsNotTaken',
          citation: 'Too many roads not taken: Aled M. Edwards, Ruth Isserlin, Gary D. Bader, Stephen V. Frye, Timothy M. Willson & Frank H. Yu Nature 470, 163-165 (10 February 2011) doi:10.1038/470163a',
          site_url: 'http://baderlab.org/Data/RoadsNotTaken',
          source_db_version: 'February 2014',
          source_type_id: DataModel::SourceType.POTENTIALLY_DRUGGABLE,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name: 'BaderLabGenes',
          full_name: 'Bader Lab Genes',
          license: 'Supplemental data from CC-BY 3.0 arXiv preprint',
          license_link: 'http://baderlab.org/Data/RoadsNotTaken',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, BaderLabRow, source_info do
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
