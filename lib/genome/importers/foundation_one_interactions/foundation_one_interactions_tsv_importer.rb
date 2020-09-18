module Genome
  module Importers
    module FoundationOneInteractions

      def self.source_info
        {
          base_url: 'http://www.foundationone.com/help/current-gene-list.php',
          citation: 'High-throughput detection of actionable genomic alterations in clinical tumor samples by targeted, massively parallel sequencing. Wagle N, Berger MF, ..., Meyerson M, Gabriel SB, Garraway LA. Cancer Discov. 2012 Jan;2(1):82-93',
          site_url: 'http://www.foundationone.com/',
          source_db_version: '9-Oct-2013',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          source_db_name: 'Foundation One',
          full_name: 'Foundation One',
          license: 'Unknown; data is no longer publicly available from site',
          license_link: 'https://www.foundationmedicine.com/resource/legal-and-privacy',
        }
      end

      def self.run(tsv_path)
        TSVImporter.import tsv_path, FoundationOneInteractionsRow, source_info do
          interaction known_action_type: 'unknown' do
            attribute :pharmacogenomic_loci_hg19, name: 'Pharmacogenomic Loci (hg19)'

            gene :entrez_gene_name, nomenclature: 'Entrez Gene Name' do
              name :entrez_gene_id, nomenclature: "Entrez Gene ID"
              attribute :reported_gene_name, nomenclature: 'Source Reported Gene Name'
              attribute :gene_category, nomenclature: "Gene Category"
            end

            drug :primary_drug_name, nomenclature: 'Primary Drug Name', primary_name: :primary_drug_name, transform: upcase do
              name :pubchem_drug_name, nomenclature: 'Pubchem Drug Name'
              name :pubchem_drug_id, nomenclature: 'Pubchem Drug ID'
              attribute :reported_drug_name, name: 'Reported Drug Name'
            end
          end
        end.save!
      end
    end
  end
end
