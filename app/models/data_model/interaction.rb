module DataModel
  class Interaction < ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey

    has_many :interaction_claims
    belongs_to :gene
    belongs_to :drug
    has_and_belongs_to_many :interaction_types,
      :join_table => "interaction_types_interactions",
      :class_name => "InteractionClaimType"
    has_many :interaction_attributes
    has_and_belongs_to_many :publications
    has_and_belongs_to_many :sources

    def source_names
      self.sources.pluck(:source_db_name).uniq
    end

    def type_names
      self.interaction_types.pluck(:type).uniq
    end

    def pmids
      self.publications.pluck(:pmid).uniq
    end

    def directionality
      if self.interaction_types.loaded?
        self.interaction_types
          .reject { |it| it.directionality.nil? }
          .map { |it| it.directionality }
          .uniq
      else
        self.interaction_types.where.not(directionality: nil).distinct.pluck(:directionality)
      end
    end

    def self.for_tsv
      eager_load(:gene, :drug, :interaction_types, :sources)
    end

    def self.for_show
      eager_load(:gene, :drug, :interaction_types, :interaction_attributes, :publications, interaction_claims: [:drug_claim, :gene_claim, :interaction_claim_types, :interaction_claim_attributes, :publications, :interaction_claim_links, source: [:source_type]])
    end

    def interaction_score(known_drug_partners_per_gene = nil, known_gene_partners_per_drug = nil)
      if known_drug_partners_per_gene.nil?
        known_drug_partners_per_gene = DataModel::Interaction.group(:gene_id).count
      end
      average_known_drug_partners_per_gene = known_drug_partners_per_gene.values.sum / known_drug_partners_per_gene.values.size.to_f
      if known_gene_partners_per_drug.nil?
        known_gene_partners_per_drug = DataModel::Interaction.group(:drug_id).count
      end
      average_known_gene_partners_per_drug = known_gene_partners_per_drug.values.sum / known_gene_partners_per_drug.values.size.to_f
      known_drug_partners_for_interaction_gene = known_drug_partners_per_gene[self.gene_id]
      known_gene_partners_for_interaction_drug = known_gene_partners_per_drug[self.drug_id]

      (self.publications.count + self.sources.count) * average_known_gene_partners_per_drug/known_gene_partners_for_interaction_drug * average_known_drug_partners_per_gene/known_drug_partners_for_interaction_gene
    end
  end
end
