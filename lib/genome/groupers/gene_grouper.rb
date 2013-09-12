module Genome
  module Groupers
    class GeneGrouper

      def self.run
        ActiveRecord::Base.transaction do
          puts 'Preloading genes and gene names into memory.'
          preload!
          puts 'Creating initial gene groups.'
          create_groups
          puts 'Adding members to gene groups.'
          add_members
          puts 'Committing to database.'
        end
      end

      private
      def self.preload!
        @gene_names_to_genes = preload_gene_names
        @alt_to_entrez = preload_entrez_gene_aliases
        @alt_to_other = preload_non_entrez_gene_aliases
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
        DataModel::GeneClaimAlias.includes(gene_claim: [:genes, :source])
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
          gene = @gene_names_to_genes[gene_name].first

          if gene
            gene_claims.each do |gene_claim|
              gene_claim.genes << gene unless gene_claim.genes.include?(gene)
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
              indirect_gene = alt_gene.genes.first
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
        gene.gene_claims << gene_claim unless gene.gene_claims.include?(gene_claim)
      end

      def self.gene_claims_not_in_groups
        DataModel::GeneClaim.eager_load(:genes, :gene_claim_aliases)
          .where('gene_claims_genes.gene_id IS NULL')
      end
    end
  end
end
