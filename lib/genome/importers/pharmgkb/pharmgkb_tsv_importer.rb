module Genome
  module Importers
    module Pharmgkb
      def source_info
        {
          base_url:          'http://www.pharmgkb.org',
          site_url:          'http://www.pharmgkb.org/',
          citation:          "From pharmacogenomic knowledge acquisition to clinical applications: the PharmGKB as a clinical pharmacogenomic biomarker resource. McDonagh EM, Whirl-Carrillo M, Garten Y, Altman RB, Klein TE. Biomark Med. 2011 Dec;5(6):795-806. PMID: 22103613",
          source_db_version:  '12-Jul-2012',
          source_type_id:    DataModel::SourceType.INTERACTION,
          source_db_name:    'PharmGKB',
          full_name:         'PharmGKB - The Pharmacogenomics Knowledgebase',
          license:           'Creative Commons Attribution-ShareAlike 4.0 International License',
          license_url:       'https://www.pharmgkb.org/page/faqs',
        }
      end

      def self.run(tsv_path)
        na_filter = ->(x) { x.upcase == 'N/A' }
        TSVImporter.import tsv_path, PharmgkbRow, source_info do
          interaction known_action_type: 'unknown' do
            attribute 'Interaction Type', name: 'n/a'

            gene :Entity2_id, nomenclature: 'PharmGKB Gene Accession' do
              name :Entrez_Id, nomenclature: 'Entrez Gene Id', unless: na_filter
              name :Ensembl_Id, nomenclature: 'Ensembl Gene Id', unless: na_filter
              name :Gene_Name, nomenclature: 'Gene Name', unless: na_filter
              name :Symbol, nomenclature: 'Gene Symbol', unless: na_filter
              names :Alternate_Names, nomenclature: 'Alternate Gene Name', transform: ->(x) {x.gsub!(/\"/, '')}, unless: na_filter
              names :Alternate_Symbols, nomenclature: 'Gene Synonym', transform: ->(x) {x.gsub!(/\"/, '')}, unless: na_filter
              attribute :Is_VIP, name: 'Is VIP', unless: na_filter
              attribute :Has_Variant_Annotation, name: 'Has Variant Annotation', unless: na_filter
            end

            drug :Entity1_id, nomenclature: 'PharmGKB' do
              name :Entity1_id, nomenclature: 'PharmGKB Drug Accession'
              name :Drug_Name, nomenclature: 'Primary Drug Name'
              names :Generic_Names, nomenclature: 'Drug Generic Name', unless: na_filter
              names :Trade_Names, nomenclature: 'Drug Trade Name', unless: na_filter
              #TODO: handle Drug_Cross_References (value will be a ':' delmited name, nomenclature)
              #names :Drug_Cross_References #TODO: this is going to be a pain in the ass
              name :SMILES, nomenclature: 'SMILES', unless: na_filter
              #TODO: handle External_Vocabulary (value will be a ':' delmited name, nomenclature)
              #attribute: External_Vocabulary
              attribute :Drug_Type, name: 'Drug Type', unless: na_filter
            end
          end
        end
        s = DataModel::Source.where(source_db_name: source_info['source_db_name'])
        s.interaction_claims.each do |ic|
          Genome::OnlineUpdater.new.create_interaction_claim_link(ic, 'Drug Label Annotations', "https://www.pharmgkb.org/chemical/#{ic.drug_claim.name}/labelAnnotation")
        end
      end
    end
  end
end
