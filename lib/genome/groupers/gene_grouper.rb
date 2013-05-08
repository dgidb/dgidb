module Genome
  module Groupers
    class GeneGrouper
      @alt_to_entrez = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_other = Hash.new() {|hash, key| hash[key] = []}

      def self.run
        ActiveRecord::Base.transaction do
          puts 'preload'
          preload
          puts 'create groups'
          create_groups
          puts 'add members'
          add_members
        end
      end

      def self.preload
        DataModel::GeneClaimAlias.includes(gene_claim: [:genes, :source]).all.each do |gca|
          gene_claim_alias = gca.alias
          next if gene_claim_alias.length == 1
          next if gene_claim_alias =~ /^\d\d$/

          if gca.nomenclature == 'Gene Symbol' && gca.gene_claim.source.source_db_name == 'Entrez'
            @alt_to_entrez[gene_claim_alias] << gca
          else
            @alt_to_other[gene_claim_alias] << gca
          end
        end
      end

      def self.create_groups
        @alt_to_entrez.each_key do |key|
          gene_claims = @alt_to_entrez[key].map(&:gene_claim)
          gene = DataModel::Gene.where(name: key).first
          if gene
            gene_claims.each do |gene_claim|
              gene_claim.genes << gene unless gene_claim.genes.include?(gene)
              gene_claim.save
            end
          else
            DataModel::Gene.new.tap do |g|
              g.name = key
              g.gene_claims = gene_claims
              g.save
            end
          end
        end
      end

      def self.add_members
        DataModel::GeneClaim.all.each do |gene_claim|
          next if gene_claim.genes.any?
          indirect_groups = Hash.new { |h, k| h[k] = 0 }
          direct_groups = Hash.new { |h, k| h[k] = 0 }

          direct_groups[gene_claim.name] += 1 if DataModel::Gene.where(name: gene_claim.name).any?
          gene_claim.gene_claim_aliases.each do |gene_claim_alias|
            direct_groups[gene_claim_alias.alias] +=1 if DataModel::Gene.where(name: gene_claim_alias.alias).any?
            alt_genes = @alt_to_other[gene_claim_alias].map(&:gene_claim)
            alt_genes.each do |alt_gene|
              indirect_gene = alt_gene.genes.first
              indirect_groups[indirect_gene.name] += 1 if indirect_gene
            end
          end

          if direct_groups.keys.length == 1
            gene = DataModel::Gene.where(name: direct_groups.keys.first).first
            gene.gene_claims << gene_claim unless gene.gene_claims.include?(gene_claim)
            gene.save
          elsif direct_groups.keys.length == 0 && indirect_groups.keys.length == 1
            gene = DataModel::Gene.where(name: indirect_groups.keys.first).first
            gene.gene_claims << gene_claim unless gene.gene_claims.include?(gene_claim)
            gene.save
          end
        end
      end
    end
  end
end
