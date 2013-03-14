module Genome
  module Groupers
    class GeneGrouper
      @alt_to_entrez = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_other = Hash.new() {|hash, key| hash[key] = []}

      def self.run
        preload
        create_groups
        add_members
      end

      def self.preload
        DataModel::GeneClaimAlias.each do |gca|
          gene_claim_alias = gca.alias
          next if gene_claim_alias =~ /^.$/
            next if gene_claim_alias =~ /^\d\d$/

            if(gca.nomenclature == 'Gene Symbol' and gca.gene_claim.citation.source_db_name == 'Entrez')
              alt_to_entrez[gene_claim_alias].push(gca)
            else
              alt_to_other[gene_claim_alias].push(gca)
            end
        end
      end

      def self.create_groups
        alt_to_entrez.each_key do |key|
          gene_claims = alt_to_entrez[key].map{|a| a.gene_claim}
          gene = DataModel::Gene.where(name: key)
          if gene
            gene_claims.each do |gene_claim|
              gene_claim.genes.push(gene) unless gene_claim.genes.include?(gene)
            end
          else
            DataModel::Gene.new.tap do |g|
              g.name = key,
                g.long_name = '', #TODO: fill me in
                g.gene_claims = gene_claims
            end
          end
        end
      end

      def self.add_members
        DataModel::GeneClaim.all.each do |gene_claim|
          next unless gene_claim.genes.empty?
          indirect_groups = Hash.new { |h, k| h[k] = 0 }
          direct_groups = Hash.new { |h, k| h[k] = 0 }

          direct_groups[gene_claim.name] += 1 if DataModel::Gene.where(name: gene_claim.name).any?
          gene_claim.gene_claim_alias.each do |gene_claim_alias|
            direct_groups[gene_claim_alias.alias] +=1 if DataModel::Gene.where(name: gene_claim_alias.alias).any?
            alt_genes = alt_to_other[gene_claim_alias].map{|a| a.gene_claim}
            alt_genes.each do |alt_gene|
              indirect_name = alt_gene.genes.map{|g| g.name} #THIS IS BAD, M'KAY
              indirect_group[indirect_name] += 1 if indirect_name
            end

            if direct_groups.keys.length == 1
              gene = DataModel::Gene.where(name: direct_groups.keys.first).first
              gene.gene_claims.push(gene_claim)
            elsif direct_groups.keys.length == 0 && indirect_groups.keys.length == 1
              gene = DataModel::Gene.where(name: indirect_groups.key.first).first
              gene.gene_claims.push(gene_claim)
            end
          end
        end
      end
    end
  end
end
