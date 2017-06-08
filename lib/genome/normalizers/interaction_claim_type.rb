module Genome
  module Normalizers
    class InteractionClaimType
      def self.normalize_types
        ActiveRecord::Base.transaction do
          fill_in_new_types
          backfill_with_default_type
          cleanup_type(default_type)
          cleanup_type(other_type)
        end
      end

      
      def self.fill_in_new_types
        existing_types = all_interaction_claim_types
        claim_type_attributes.each do |ica|
          if type = existing_types[name_normalizer(ica.value)]
            add_unless_exists(type, ica.interaction_claim)
          end
          ica.delete
        end
      end

      def self.cleanup_type(type)
        interaction_claims_with_more_than_one_type = type.interaction_claims
          .reject { |ic| ic.interaction_claim_types.size == 1 }
        interaction_claims_with_more_than_one_type.each do |ic|
          ic.interaction_claim_types.delete(type)
          ic.save
        end
      end

      def self.backfill_with_default_type
        type = default_type
        interactions_with_no_type = DataModel::InteractionClaim.eager_load(:interaction_claim_types)
          .select { |ic| ic.interaction_claim_types.size == 0 }
        interactions_with_no_type.each do |i|
          i.interaction_claim_types << type
        end
      end

      def self.default_type
        DataModel::InteractionClaimType.where(type: 'n/a').first
      end

      def self.other_type
        DataModel::InteractionClaimType.where(type: 'other/unknown').first
      end

      def self.add_unless_exists(type, interaction_claim)
        unless interaction_claim.interaction_claim_types.include?(type)
          interaction_claim.interaction_claim_types << type
        end
      end

      def self.name_normalizer(val)
        val = val.downcase
        if val == 'na' || val == 'n/a'
          'n/a'
        elsif val =~ /other/ || val =~ /unknown/
          'other/unknown'
        else
          val
        end
      end

      def self.claim_type_attributes
        DataModel::InteractionClaimAttribute.where('lower(name) = ?', 'interaction type')
        .includes(interaction_claim: [:interaction_claim_types])
      end

      def self.all_interaction_claim_types
        DataModel::InteractionClaimType.all.each_with_object({}) do |i, h|
          h[i.type] = i
        end
      end
    end
  end
end