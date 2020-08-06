module Genome
  module Importers
    module DrugBank

      def self.get_version
        File.open('lib/genome/updaters/data/version').readlines.each do |line|
          source, version = line.split("\t")
          if source == 'DrugBank'
            return version.strip
          end
        end
        return nil
      end

      def self.source_info
        {
          base_url: 'http://www.drugbank.ca',
          site_url: 'http://www.drugbank.ca/',
          citation: "DrugBank 4.0: shedding new light on drug metabolism. Law V, Knox C, Djoumbou Y, Jewison T, Guo AC, Liu Y, Maciejewski A, Arndt D, Wilson M, Neveu V, Tang A, Gabriel G, Ly C, Adamjee S, Dame ZT, Han B, Zhou Y, Wishart DS.Nucleic Acids Res. 2014 Jan 1;42(1):D1091-7. PubMed ID: 24203711",
          source_db_version: get_version,
          source_type_id: DataModel::SourceType.INTERACTION,
          source_db_name: 'DrugBank',
          full_name: 'DrugBank - Open Data Drug & Drug Target Database',
          source_trust_level_id: DataModel::SourceTrustLevel.EXPERT_CURATED,
          license: '',
          license_url: 'https://dev.drugbankplus.com/guides/drugbank/citing?_ga=2.29505343.1251048939.1591976592-781844916.1591645816',
        }
      end

      def self.run(tsv_path)
        blank_filter = ->(x) { x.blank? || x == "''" || x == '""' || x.downcase.tr('/','') == 'na'}
        upcase = ->(x) {x.upcase}
        downcase = ->(x) {x.downcase}
        TSVImporter.import tsv_path, DrugBankRow, source_info do
          interaction known_action_type: :known_action, transform: downcase do
            drug :drug_id, nomenclature: 'DrugBank Drug Identifier', primary_name: :drug_name, transform: upcase do
              name :drug_name, nomenclature: 'DrugBank Drug Name', transform: upcase
              names :drug_synonyms, nomenclature: 'Drug Synonym', unless: blank_filter
              name :drug_cas_number, nomenclature: 'CAS Number', unless: blank_filter
              names :drug_brands, nomenclature: 'Drug Brand', unless: blank_filter
              attribute :drug_type, name: 'Drug Type', unless: blank_filter
              attributes :drug_groups, name: 'Drug Groups', unless: blank_filter
              attributes :drug_categories, name: 'Drug Categories', unless: blank_filter
            end
            gene :gene_id, nomenclature: 'DrugBank Gene Identifier' do
              name :gene_symbol, nomenclature: 'DrugBank Gene Name', unless: blank_filter
              name :uniprot_id, nomenclature: 'UniProt Accession', unless: blank_filter
              name :entrez_id, nomenclature: 'Entrez Gene Id', unless: blank_filter
              name :ensembl_id, nomenclature: 'Ensembl Gene Id', unless: blank_filter
              # target_ligand fields are ignored for now.
            end
            attributes :target_actions, name: 'Interaction Type', transform: downcase, unless: blank_filter
            attributes :pmid, name: 'PMID', unless: blank_filter
          end
        end.save!
      end
    end
  end
end
