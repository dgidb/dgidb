module Genome
  module Groupers
    class InteractionGrouper
      def self.run(group_from_scratch=false)
        if group_from_scratch
          ActiveRecord::Base.transaction do
            puts 'reset members'
            reset_members
            puts 'add members'
            add_members(group_from_scratch)
          end
        else
          puts 'add members'
          add_members(group_from_scratch)
        end
      end

      def self.reset_members
        DataModel::InteractionClaim.update_all(interaction_id: nil)
        DataModel::InteractionAttribute.destroy_all
        DataModel::Interaction.destroy_all
      end

      def self.add_members(group_from_scratch)
        DataModel::InteractionClaim.eager_load(:interaction_claim_types, :source, :interaction_claim_attributes, :publications).joins(drug_claim: [:drug], gene_claim: [:gene]).where(interaction_id: nil).in_batches do |interaction_claims|
          interaction_claims.each do |interaction_claim|
            if group_from_scratch
              add_member(interaction_claim)
            else
              ActiveRecord::Base.transaction do
                add_member(interaction_claim)
              end
            end
          end
        end
      end

      def self.add_member(interaction_claim)
        drug = interaction_claim.drug_claim.drug
        gene = interaction_claim.gene_claim.gene
        interaction = DataModel::Interaction.where(drug_id: drug.id, gene_id: gene.id).first_or_create
        interaction_claim.interaction = interaction

        #roll types up to interaction level
        interaction_claim.interaction_claim_types.each do |t|
          unless interaction.interaction_types.include? t
            interaction.interaction_types << t
          end
        end

        # roll sources up to interaction level
        unless interaction.sources.include? interaction_claim.source
          interaction.sources << interaction_claim.source
        end
        interaction_claim.interaction_claim_attributes.each do |ica|
          interaction_attribute = DataModel::InteractionAttribute.where(
            interaction_id: interaction.id,
            name: ica.name,
            value: ica.value
          ).first_or_create
          unless interaction_attribute.sources.include? interaction_claim.source
            interaction_attribute.sources << interaction_claim.source
          end
        end

        #roll publications up to interaction level
        interaction_claim.publications.each do |pub|
          interaction.publications << pub unless interaction.publications.include? pub
        end

        interaction_claim.save
        interaction.save

        # these actions might be unnecessary if we create interaction types and publications directly
        DataModel::InteractionAttribute.where(name: 'PMID').destroy_all
        DataModel::InteractionAttribute.where(name: 'PubMed ID for Interaction').destroy_all
        DataModel::InteractionAttribute.where(name: 'Interaction Type').destroy_all
      end
    end
  end
end
