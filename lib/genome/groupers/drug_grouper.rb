module Genome
  module Groupers
    class DrugGrouper
      @alt_to_pubchem = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_other = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_pubchem_sid = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_pubchem_cid = Hash.new() {|hash, key| hash[key] = []}

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
        DataModel::DrugClaimAlias.includes(drug_claim: [:drugs, :source]).all.each do |dca|
          drug_claim_alias = dca.alias
          if drug_claim_alias =~ /^\d+$/
            if dca.nomenclature =~ /pubchem.*(substance)|(sid)/i
              @alt_to_pubchem_sid[drug_claim_alias] << dca
            elsif dca.nomenclature =~ /pubchem.*(compound)|(cid)/i
              @alt_to_pubchem_cid[drug_claim_alias] << dca
            else
              next
            end
          elsif drug_claim_alias.length == 1
            next
          elsif dca.nomenclature == 'pubchem_primary_name'
            @alt_to_pubchem[drug_claim_alias] << dca
          else
            @alt_to_other[drug_claim_alias] << dca
          end
        end
      end

      def self.create_groups
        @alt_to_pubchem.each_key do |key|
          drug_claims = @alt_to_pubchem[key].map(&:drug_claim)
          drug = DataModel::Drug.where(name: key).first
          if drug 
            drug_claims.each do |drug_claim|
              drug_claim.drugs << drug unless drug_claim.drugs.include?(drug)
              drug_claim.save
            end
          else
            DataModel::Drug.new.tap do |g|
              g.name = key
              g.drug_claims = drug_claims
              g.save
            end
          end
        end
      end

      def self.add_members
        DataModel::DrugClaim.all.each do |drug_claim|
          next if drug_claim.drugs.any?
          indirect_groups = Hash.new { |h, k| h[k] = 0 }
          direct_groups = Hash.new { |h, k| h[k] = 0 }
          direct_groups[drug_claim.name] += 1 if DataModel::Drug.where(name: drug_claim.name).any?
          drug_claim.drug_claim_aliases.each do |drug_claim_alias|
            direct_groups[drug_claim_alias.alias] +=1 if DataModel::Drug.where(name: drug_claim_alias.alias).any?
            alt_drugs = @alt_to_other[drug_claim_alias.alias].map(&:drug_claim)
            alt_drugs.each do |alt_drug|
              indirect_drug = alt_drug.drugs.first
              indirect_groups[indirect_drug.name] += 1 if indirect_drug
            end
            nomenclature = drug_claim_alias.nomenclature
            if nomenclature =~ /pubchem.*(substance)|(sid)/i
              alt_drugs = @alt_to_pubchem_sid[drug_claim_alias.alias].map(&:drug_claim)
              alt_drugs.each do |alt_drug|
                next unless alt_drug.nomenclature =~ /pubchem.*(substance)|(sid)/i
                indirect_drug = alt_drug.drugs.first
                indirect_groups[indirect_drug.name] += 1 if indirect_drug
              end
            elsif nomenclature =~ /pubchem.*(compound)|(cid)/i
              alt_drugs = @alt_to_pubchem_cid[drug_claim_alias.alias].map(&:drug_claim)
              alt_drugs.each do |alt_drug|
                next unless alt_drug.nomenclature =~ /pubchem.*(compound)|(cid)/i
                indirect_drug = alt_drug.drugs.first
                indirect_groups[indirect_drug.name] += 1 if indirect_drug
              end
            end
          end

          if direct_groups.keys.length == 1
            drug = DataModel::Drug.where(name: direct_groups.keys.first).first
            drug.drug_claims << drug_claim unless drug.drug_claims.include?(drug_claim)
            drug.save
          elsif direct_groups.keys.length == 0 && indirect_groups.keys.length == 1
            drug = DataModel::Drug.where(name: indirect_groups.keys.first).first
            drug.drug_claims << drug_claim unless drug.drug_claims.include?(drug_claim)
            drug.save
          end
        end
      end
    end
  end
end
