  module Genome
    module Importers
      module MyCancerGenome
        def self.source_info
          {
              base_url: 'http://www.mycancergenome.org/',
              citation: 'http://www.mycancergenome.org/',
              site_url: 'http://www.mycancergenome.org/',
              source_db_version: '30-Feburary-2014',
              source_type_id: DataModel::SourceType.INTERACTION,
              source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
              source_db_name: 'MyCancerGenomeClinicalTrial',
              full_name: 'MyCancerGenome Clinical Trial',
          }
        end

        def self.run(tsv_path)
          blank_filter = ->(x) { x.blank? }
          upcase = ->(x) { x.upcase }

          TSVImporter.import tsv_path, MyCancerGenomeClinicalRow, source_info do
            interaction known_action_type: :interaction_type do
              attribute :interaction_type, name: 'Interaction Type'
              gene :entrez_gene_name, nomenclature: 'Gene Target Symbol', transform: upcase do
                name :entrez_gene_id, nomenclature: 'Entrez Gene ID'
                attribute :molecular_target, name: 'Reported Genome Event Targeted'
              end

              drug :pubchem_name, nomenclature: 'Primary Drug Name', primary_name: :pubchem_name, transform: upcase do
                attribute :drug_class, name: 'Drug Class'
                name :drug_name, nomenclature: 'Drug Trade Name', unless: blank_filter
                name :cid, nomenclature: 'PubChem Drug ID', unless: blank_filter
                names :other_drug_names, nomenclature: 'Other Drug Name', unless: blank_filter
                attribute :clinical_trial_id, name: 'Clinical Trial ID'
              end

              attribute :disease, name: 'Type of Cancer Targeted'
            end
          end.save!
        end
      end
    end
  end
