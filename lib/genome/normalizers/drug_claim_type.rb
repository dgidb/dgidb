module Genome
  module Normalizers
    class DrugTypeNormalizers

      def self.normalize_types
        antineoplastic_type = DataModel::DrugClaimType.where(type: 'antineoplastic').first
        drug_claims = antineoplastic_drugs
        puts "Found #{drug_claims.size} total antineoplastic drugs"
        drug_claims.each do |dc|
          unless dc.drug_claim_types.include? antineoplastic_type
            dc.drug_claim_types << antineoplastic_type
            dc.save
          end
        end
      end

      private
      def self.antineoplastic_drugs
        drug_claims_with_attributes = DataModel::DrugClaim.includes(:drug_claim_attributes)
          .where('drug_claim_attributes.value' => antineoplastic_type_names)
        drug_claims_from_sources = DataModel::DrugClaim.includes(:source)
          .where('sources.source_db_name' => antineoplastic_source_names)

        (drug_claims_from_sources + drug_claims_with_attributes).uniq { |dc| dc.id }
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
          'ClearityFoundationClinicalTrial'
        ]
      end
    end
  end
end
