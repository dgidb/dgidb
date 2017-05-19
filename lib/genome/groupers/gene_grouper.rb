module Genome
  module Groupers
    class GeneGrouper

      def self.run
        ActiveRecord::Base.transaction do
          preload
          create_groups
          @alt_to_other = preload_non_entrez_gene_aliases
          add_members
          add_aliases
          add_attributes
          add_categories
        end
      end

      private
      def self.preload
        @gene_names_to_genes = preload_gene_names
        @alt_to_entrez = preload_entrez_gene_aliases
      end

      def self.preload_entrez_gene_aliases
        gene_claim_aliases = gene_claim_alias_scope
          .where(nomenclature: 'Gene Symbol')
          .where('sources.source_db_name' => 'Entrez')

        preload_aliases(gene_claim_aliases)
      end

      def self.preload_non_entrez_gene_aliases
        gene_claim_aliases = gene_claim_alias_scope
          .where('gene_claim_aliases.nomenclature != ? OR sources.source_db_name != ?',
                 'Gene Symbol', 'Entrez')

          preload_aliases(gene_claim_aliases)
      end

      def self.gene_claim_alias_scope
        DataModel::GeneClaimAlias.includes(gene_claim: [:gene, :source])
      end

      def self.preload_aliases(query)
        name_hash = Hash.new() { |hash, key| hash[key] = [] }
        query.reject { |gca| gca.alias.length == 1 || gca.alias =~ /^\d\d$/ }
          .each_with_object(name_hash) do |gca, h|
              h[gca.alias] << gca
        end
      end

      def self.preload_gene_names
        DataModel::Gene.includes(:gene_claims).all.group_by(&:name)
      end

      def self.create_groups
        @alt_to_entrez.each_key do |gene_name|
          gene_claims = @alt_to_entrez[gene_name].map(&:gene_claim)
          gene = @gene_names_to_genes[gene_name].first if @gene_names_to_genes[gene_name]

          if gene
            gene_claims.each do |gene_claim|
              gene_claim.gene = gene if gene_claim.gene.nil?
              gene_claim.save
            end
          else
            @gene_names_to_genes[gene_name] = [DataModel::Gene.new.tap do |g|
              g.name = gene_name
              g.gene_claims = gene_claims
              g.save
            end]
          end
        end
      end

      def self.add_members
        gene_claims_not_in_groups.each do |gene_claim|

          indirect_groups = []
          direct_groups = []

          direct_groups << gene_claim.name if @gene_names_to_genes[gene_claim.name]
          gene_claim.gene_claim_aliases.map(&:alias).each do |gene_claim_alias|
            direct_groups << gene_claim_alias if @gene_names_to_genes[gene_claim_alias]
            alt_genes = @alt_to_other[gene_claim_alias].map(&:gene_claim)
            alt_genes.each do |alt_gene|
              indirect_gene = alt_gene.gene
              indirect_groups << indirect_gene.name if indirect_gene
            end
          end

          if direct_groups.uniq.size == 1
            add_gene_claim_to_gene(direct_groups.first, gene_claim)
          elsif direct_groups.uniq.size == 0 && indirect_groups.size == 1
            add_gene_claim_to_gene(indirect_groups.first, gene_claim)
          end
        end
      end

      def self.add_gene_claim_to_gene(gene_name, gene_claim)
        gene = @gene_names_to_genes[gene_name].first
        gene_claim.gene = gene
        gene_claim.save
      end

      def self.gene_claims_not_in_groups
        DataModel::GeneClaim.eager_load(:gene, :gene_claim_aliases)
          .where('gene_claims.gene_id IS NULL')
      end

      def self.add_aliases
        DataModel::Gene.all.each do |gene|
          grouped_gene_claim_aliases = gene.gene_claims.flat_map(&:gene_claim_aliases).group_by { |gca| gca.alias.upcase }
          grouped_gene_claim_aliases.each do |name, gene_claim_aliases_for_name|
            groups = gene_claim_aliases_for_name.group_by{ |gca| gca.alias }
            counts_for_name = groups.each_with_object(Hash.new) do |(n, gcas), counts|
              counts[n] = gcas.length
            end
            best_name = Hash[counts_for_name.sort_by{ |n, count| count }.reverse].keys.first
            gene_alias = DataModel::GeneAlias.where(
              gene_id: gene.id,
              alias: best_name,
            ).first_or_create
            gene_claim_aliases_for_name.each do |gca|
              unless gene_alias.sources.include? gca.gene_claim.source
                gene_alias.sources << gca.gene_claim.source
              end
            end
            gene_alias.save
          end
        end
      end

      def self.add_attributes
        DataModel::Gene.all.each do |gene|
          gene.gene_claims.each do |gene_claim|
            gene_claim.gene_claim_attributes.each do |gca|
              existing_gene_attributes = DataModel::GeneAttribute.where(
                gene_id: gene.id,
                name: gca.name,
                value: gca.value
              )
              if existing_gene_attributes.empty?
                DataModel::GeneAttribute.new.tap do |a|
                  a.gene = gene
                  a.name = gca.name
                  a.value = gca.value
                  a.sources << gene_claim.source
                  a.save
                end
              else
                existing_gene_attributes.each do |gene_attribute|
                  unless gene_attribute.sources.include? gene_claim.source
                    gene_attribute.sources << gene_claim.source
                  end
                end
              end
            end
          end
        end
      end

      def self.add_categories
        DataModel::Gene.all.each do |gene|
          gene.gene_claims.each do |gene_claim|
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
end
