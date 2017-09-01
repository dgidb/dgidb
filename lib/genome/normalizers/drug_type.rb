module Genome
  module Normalizers
    class DrugTypeNormalizer

      def self.normalize_types
        drugs = antineoplastic_drugs
        puts "Found #{drugs.size} total antineoplastic drugs"
        drugs.each do |d|
          d.anti_neoplastic = true
          d.save!
        end
        drugs = immunotherapy_drugs
        puts "Found #{drugs.size} total immunotherapy drugs"
        drugs.each do |d|
          d.immunotherapy = true
          d.save!
        end
      end

      private
      def self.antineoplastic_drugs
        drugs_with_attributes = DataModel::Drug.includes(:drug_attributes).where('drug_attributes.value' => antineoplastic_type_names)
        drugs_from_sources = DataModel::Drug.includes(drug_claims: [:source]).where('sources.source_db_name' => antineoplastic_source_names)

        (drugs_from_sources + drugs_with_attributes).uniq { |d| d.id }
      end

      def self.immunotherapy_drugs
        DataModel::Drug.includes(:drug_attributes).where('drug_attributes.value' => immunotherapy_type_names)
      end

      def self.immunotherapy_type_names
        [
            "immunosuppressive agents",
            "immunosuppressant",
            "immunomodulatory agents",
            "immunomodulatory agent",
            "immunostimulant",
            "immunosuppressive agent"
        ]
      end

      def self.antineoplastic_type_names
        [
          'antineoplastic agents',
          'antineoplastic agents, protein kinase inhibitors',
          'antineoplastic adjuncts',
          'antineoplastic agents, hormonal',
          'antineoplastic agents, homeopathic agents',
          'antineoplastic agent',
          'antineoplastic agents',
          'antineoplastic agent',
          'antineoplastic agents, phytogenic',
          'anticancer agents',
          'antineoplastic',
          'anticarcinogenic agents',
          'antineoplastics'
        ]
      end

      def self.antineoplastic_source_names
        [
          'TALC',
          'MyCancerGenome',
          'MyCancerGenomeClinicalTrial',
          'CancerCommons',
          'ClearityFoundationBiomarkers',
          'ClearityFoundationClinicalTrial',
          'CKB',
          'OncoKB',
        ]
      end
    end
  end
end
