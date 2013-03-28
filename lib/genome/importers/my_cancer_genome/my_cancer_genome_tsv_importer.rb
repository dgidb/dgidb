module Genome
  module Importers
    module MyCancerGenome

      @source_info = {
        base_url: 'http://www.mycancergenome.org/content/other/molecular-medicine/targeted-therapeutics',
        site_url: 'http://www.mycancergenome.org/',
        citation: 'DNA-mutation Inventory to Refine and Enhance Cancer Treatment (DIRECT): A catalogue of clinically relevant cancer mutations to enable genome-directed cancer therapy. Yeh P, Chen H, Andrews J, Naser R, Pao W, Horn L. Clin Cancer Res. 2013 Jan 23. [Epub ahead of print]. PMID: 23344264.',
        source_db_version: '13-Mar-2013',
        source_type_id: DataModel::SourceType.INTERACTION,
        source_db_name: 'MyCancerGenome',
        full_name: 'My Cancer Genome'
      }

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? }
        TSVImporter.import tsv_path, MyCancerGenomeRow, @source_info do
          interaction known_action_type: 'unknown' do
            drug :primary_drug_name, nomenclature: 'MyCancerGenome Primary Drug Name', primary_name: :primary_drug_name do
              attribute :drug_class, name: 'Drug Class', unless: blank_filter
              attribute :notes, name: 'Notes', unless: blank_filter
              names :drug_development_name, nomenclature: 'Development Name', unless: blank_filter
              names :drug_generic_name, nomenclature: 'Generic Name', unless: blank_filter
              names :drug_trade_name, nomenclature: 'Trade Name', unless: blank_filter
            end
            gene :gene_symbol, nomenclature: 'MyCancerGenome Gene Symbol' do
              name :entrez_gene_id, nomenclature: 'Entrez Gene Id', unless: blank_filter
              name :gene_symbol, nomenclature: 'MyCancerGenome Gene Symbol'
              name :reported_gene_name, nomenclature: 'MyCancerGenome Reported Gene Name', unless: blank_filter
            end

            attribute :interaction_type, name: 'Interaction Type', unless: blank_filter
          end
        end.save!
      end
    end
  end
end

