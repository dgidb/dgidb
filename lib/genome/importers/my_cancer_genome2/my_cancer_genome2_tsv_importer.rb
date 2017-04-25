module Genome
  module Importers
    module MyCancerGenome2

      def self.source_info
        {
          base_url: 'https://www.mycancergenome.org/content/molecular-medicine/overview-of-targeted-therapies-for-cancer/',
          site_url: 'http://www.mycancergenome.org/',
          citation: 'DNA-mutation Inventory to Refine and Enhance Cancer Treatment (DIRECT): A catalogue of clinically relevant cancer mutations to enable genome-directed cancer therapy. Yeh P, Chen H, Andrews J, Naser R, Pao W, Horn L. Clin Cancer Res. 2013 Jan 23. [Epub ahead of print]. PMID: 23344264.',
          source_db_version: '11-Apr-2017',
          source_type_id: DataModel::SourceType.INTERACTION,
          source_db_name: 'MyCancerGenome2017',
          full_name: 'My Cancer Genome 2017'
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? }
        TSVImporter.import tsv_path, MyCancerGenomeRow, source_info do
          interaction known_action_type: 'unknown' do
            drug :drug_name, nomenclature: 'MyCancerGenome Drug Name', primary_name: :primary_drug_name do
              attribute :drug_class, name: 'Drug Class', unless: blank_filter
              attribute :metadata_fda_approval, name: 'FDA Approved For', unless: blank_filter
              names :trade_name, nomenclature: 'Trade Name', unless: blank_filter
            end
            gene :entrez_gene_name, nomenclature: 'Entrez Gene Symbol' do
              name :reported_gene_name, nomenclature: 'MyCancerGenome Reported Gene Name', unless: blank_filter
            end
          end
        end.save!
      end
    end
  end
end

