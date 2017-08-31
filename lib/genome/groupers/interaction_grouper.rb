module Genome
  module Groupers
    class InteractionGrouper
      def self.run
        ActiveRecord::Base.transaction do
          puts 'reset members'
          reset_members
          puts 'add members'
          add_members
          puts 'add attributes'
          add_attributes
        end
      end

      def self.reset_members
        DataModel::InteractionClaim.update_all(interaction_id: nil)
        DataModel::InteractionAttribute.destroy_all
        DataModel::Interaction.destroy_all
      end

      def self.add_members
        DataModel::InteractionClaim.all.each do |interaction_claim|
          next unless interaction_claim.interaction.nil?
          drug = interaction_claim.drug_claim.drug
          next if drug.nil?
          gene = interaction_claim.gene_claim.gene
          next if gene.nil?
          interaction = DataModel::Interaction.where(drug_id: drug.id, gene_id: gene.id).first_or_create
          interaction_claim.interaction = interaction
          interaction_claim.interaction_claim_types.each do |t|
            unless interaction.interaction_types.include? t
              interaction.interaction_types << t
            end
          end
          interaction_claim.save
          interaction.save
        end
      end

      def self.add_attributes
        DataModel::Interaction.all.each do |interaction|
          interaction.interaction_claims.each do |interaction_claim|
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
            # these actions might be unnecessary if we create interaction types and publications directly
            DataModel::InteractionAttribute.where(name: 'PMID').destroy_all
            DataModel::InteractionAttribute.where(name: 'PubMed ID for Interaction').destroy_all
            DataModel::InteractionAttribute.where(name: 'Interaction Type').destroy_all
          end
        end
      end
    end
  end
end
