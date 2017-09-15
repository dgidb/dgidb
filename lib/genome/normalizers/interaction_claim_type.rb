module Genome
  module Normalizers
    class InteractionClaimType
      def self.normalize_types
        ActiveRecord::Base.transaction do
          fill_in_new_types
          cleanup_type(default_type)
          cleanup_type(other_type)
          remove_empty_types
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
        type.interaction_claims.each do |ic|
          ic.interaction_claim_types.delete(type)
          ic.save
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

      def self.remove_empty_types
        DataModel::InteractionClaimType.includes(:interaction_claims).where(interaction_claims: {id: nil}).destroy_all
      end
    end
  end
end