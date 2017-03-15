module Genome
  module Groupers
    class InteractionGrouper
      def self.run
        ActiveRecord::Base.transaction do
          puts 'add members'
          add_members
          puts 'add attributes'
          add_attributes
        end
      end

      def self.add_members
        DataModel::InteractionClaim.all.each do |interaction_claim|
          next unless interaction_claim.interaction.nil?
          drug = interaction_claim.drug_claim.drug
          next if drug.nil?
          gene = interaction_claim.gene_claim.gene
          next if gene.nil?
          existing_interactions = DataModel::Interaction.joins(:drug, :gene).where(drugs: {id: drug.id}, genes: {id: gene.id})
          if existing_interactions.first.nil?
            DataModel::Interaction.new.tap do |i|
              i.gene = gene
              i.drug = drug
              i.interaction_types << interaction_claim.interaction_claim_types
              interaction_claim.interaction = i
              i.save
              interaction_claim.save
            end
          else
            existing_interaction = existing_interactions.first
            interaction_claim.interaction = existing_interaction
            interaction_claim.save
            interaction_claim.interaction_claim_types.each do |t|
              unless existing_interaction.interaction_types.include? t
                existing_interaction.interaction_types << t
              end
            end
          end
        end
      end

      def self.add_attributes
        DataModel::Interaction.all.each do |interaction|
          interaction.interaction_claims.each do |interaction_claim|
            interaction_claim.interaction_claim_attributes.each do |ica|
              existing_interaction_attributes = DataModel::InteractionAttribute.where(
                interaction_id: interaction.id,
                name: ica.name,
                value: ica.value
              )
              if existing_interaction_attributes.empty?
                DataModel::InteractionAttribute.new.tap do |a|
                  a.interaction = interaction
                  a.name = ica.name
                  a.value = ica.value
                  a.sources << interaction_claim.source
                  a.save
                end
              else
                existing_interaction_attributes.each do |interaction_attribute|
                  unless interaction_attribute.sources.include? interaction_claim.source
                    interaction_attribute.sources << interaction_claim.source
                  end
                end
              end
            end
          end
        end
      end

    end
  end
end
