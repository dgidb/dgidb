module Genome
  module Groupers
    class InteractionGrouper
      def self.run
        ActiveRecord::Base.transaction do
          puts 'reset interactions'
          reset
          puts 'add members'
          add_members
        end
      end

      def self.reset
        DataModel::Interaction.destroy_all
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
            existing_interaction_types = existing_interactions.first.interaction_types
            interaction_claim.interaction_claim_types.each do |t|
              unless existing_interaction_types.include? t
                existing_interactions.first.interaction_types << t
              end
            end
          end
        end
      end

    end
  end
end
