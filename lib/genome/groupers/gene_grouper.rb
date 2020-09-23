module Genome
  module Groupers
    class GeneGrouper
      def run(source_id: nil)
        begin
          newly_added_claims_count = 0
          gene_claims_not_in_groups(source_id).find_in_batches do |claims|
            ActiveRecord::Base.transaction do
              grouped_claims = add_members(claims)
              newly_added_claims_count += grouped_claims.length
              if grouped_claims.length > 0
                add_attributes(grouped_claims)
                add_categories(grouped_claims)
              end
            end
          end
        end until newly_added_claims_count == 0
      end

      def add_members(claims)
        grouped_claims = []
        claims.each do |gene_claim|
          grouped_claims << group_gene_claim(gene_claim)
        end
        return grouped_claims.compact
      end

      def group_gene_claim(gene_claim)
        if (gene = DataModel::Gene.where('upper(name) = ? or upper(long_name) = ?', gene_claim.name.upcase, gene_claim.name.upcase)).one?
          add_gene_claim_to_gene(gene_claim, gene.first)
          return gene_claim
        end

        gene_claim.gene_claim_aliases.each do |gene_claim_alias|
          if (gene = DataModel::Gene.where('upper(name) = ? or upper(long_name) = ?', gene_claim_alias.alias.upcase, gene_claim_alias.alias.upcase)).one?
            add_gene_claim_to_gene(gene_claim, gene.first)
            return gene_claim
          end
        end

        if (gene_alias = DataModel::GeneAlias.where('upper(alias) = ?', gene_claim.name.upcase)).one?
          add_gene_claim_to_gene(gene_claim, gene_alias.first.gene)
          return gene_claim
        end

        gene_claim.gene_claim_aliases.each do |gene_claim_alias|
          if (gene_alias = DataModel::GeneAlias.where('upper(alias) = ?', gene_claim_alias.alias.upcase)).one?
            add_gene_claim_to_gene(gene_claim, gene_alias.first.gene)
            return gene_claim
          end
        end

        return nil
      end

      def create_gene_alias(gene_id, name, source)
          if (existing_gene_alias = DataModel::GeneAlias.where(
            'gene_id = ? and upper(alias) = ?', gene_id, name.upcase
          )).any?
            gene_alias = existing_gene_alias.first
          else
            gene_alias = DataModel::GeneAlias.where(
              gene_id: gene_id,
              alias: name
            ).first_or_create
          end
          unless gene_alias.sources.include? source
            gene_alias.sources << source
          end
      end

      def add_gene_claim_to_gene(gene_claim, gene)
        gene_claim.gene = gene
        gene_claim.save

        if (gene.name.upcase != gene_claim.name.upcase)
          create_gene_alias(gene.id, gene_claim.name, gene_claim.source)
        end

        gene_claim.gene_claim_aliases.each do |gca|
          if (gene.name.upcase != gca.alias.upcase)
            create_gene_alias(gene.id, gca.alias, gene_claim.source)
          end
        end
      end

      def gene_claims_not_in_groups(source_id)
        claims = DataModel::GeneClaim.eager_load(:gene, :gene_claim_aliases)
          .where('gene_claims.gene_id IS NULL')
        unless source_id.nil?
          claims = claims.where(source_id: source_id)
        end
        return claims
      end

      def add_attributes(claims)
        claims.each do |gene_claim|
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

      def add_categories(claims)
        claims.each do |gene_claim|
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
