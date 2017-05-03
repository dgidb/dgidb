require "set"

module Genome
  module Groupers
    class GeneGrouper
      attr_reader :newly_grouped_gene_claims
      def initialize
        @newly_grouped_gene_claims = Set.new()
      end

      def run
        ActiveRecord::Base.transaction do
          add_members
          add_attributes
          add_categories
        end
      end

      def add_members
        begin
          newly_added_claims_count = 0
          gene_claims_not_in_groups.each do |gene_claim|

            if (gene = DataModel::Gene.where('lower(name) = ?', gene_claim.name.downcase)).any?
              add_gene_claim_to_gene(gene_claim, gene.first)
              newly_added_claims_count += 1
              next
            elsif (gene_alias = DataModel::GeneAlias.where('lower(alias) = ?', gene_claim.name.downcase)).any?
              add_gene_claim_to_gene(gene_claim, gene_alias.first.gene)
              newly_added_claims_count += 1
              next
            end

            gene_claim.gene_claim_aliases.each do |gene_claim_alias|
              if (gene = DataModel::Gene.where('lower(name) = ?', gene_claim_alias.alias.downcase)).any?
                add_gene_claim_to_gene(gene_claim, gene.first)
                newly_added_claims_count += 1
                break
              elsif (gene_alias = DataModel::GeneAlias.where('lower(alias) = ?', gene_claim_alias.alias.downcase)).any?
                add_gene_claim_to_gene(gene_claim, gene_alias.first.gene)
                newly_added_claims_count += 1
                break
              end
            end
          end
        end until newly_added_claims_count == 0
      end

      def add_gene_claim_to_gene(gene_claim, gene)
        newly_grouped_gene_claims << gene_claim.id
        gene_claim.gene = gene
        gene_claim.save

        gene_claim.gene_claim_aliases.each do |gca|
          if (existing_gene_alias = DataModel::GeneAlias.where(
            'gene_id = ? and lower(alias) = ?', gene.id, gca.alias.downcase
          )).any?
            gene_alias = existing_gene_alias.first
          else
            gene_alias = DataModel::GeneAlias.where(
              gene_id: gene.id,
              alias: gca.alias
            ).first_or_create
          end
          unless gene_alias.sources.include? gene_claim.source
            gene_alias.sources << gene_claim.source
          end
        end
      end

      def gene_claims_not_in_groups
        DataModel::GeneClaim.eager_load(:gene, :gene_claim_aliases)
          .where('gene_claims.gene_id IS NULL')
      end

      def add_attributes
        DataModel::GeneClaim.where(id: newly_grouped_gene_claims.to_a).each do |gene_claim|
          gene_claim.gene_claim_attributes.each do |gca|
            gene_attribute = DataModel::GeneAttribute.where(
              gene_id: gene_claim.gene_id,
              name: gca.name,
              value: gca.value
            ).first_or_create
            unless gene_attribute.sources.include? gene_claim.source
              gene_attribute.sources << gene_claim.source
            end
            gene_attribute.save
          end
        end
      end

      def add_categories
        DataModel::GeneClaim.where(id: newly_grouped_gene_claims.to_a).each do |gene_claim|
          gene = gene_claim.gene
          gene_claim.gene_claim_categories.each do |category|
            unless gene.gene_categories.include? category
              gene.gene_categories << category
            end
          end
        end
      end

    end
  end
end
