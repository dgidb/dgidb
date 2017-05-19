module Genome
  module Groupers
    class DrugGrouper
      @alt_to_pubchem = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_other = Hash.new() {|hash, key| hash[key] = []}
      @alt_to_pubchem_cid = Hash.new() {|hash, key| hash[key] = []}

      def self.run
        ActiveRecord::Base.transaction do
          puts 'reset groups'
          reset
          puts 'preload'
          preload
          puts 'create groups'
          create_groups
          puts 'add members'
          add_members
          puts 'add drug aliases'
          add_aliases
          puts 'add drug attributes'
          add_attributes
        end
      end

      def self.reset
        DataModel::DrugClaim.all.each do |drug_claim|
          drug_claim.drug = nil
          drug_claim.save
        end
        DataModel::DrugAlias.destroy_all
        DataModel::DrugAttribute.destroy_all
        DataModel::InteractionClaim.all.each do |interaction_claim|
          interaction_claim.interaction = nil
          interaction_claim.save
        end
        DataModel::Interaction.destroy_all
        DataModel::Drug.destroy_all
      end

      def self.preload
        DataModel::DrugClaimAlias.includes(drug_claim: [:drug, :source]).all.each do |dca|
          drug_claim_alias = dca.alias
          if drug_claim_alias =~ /^\d+$/
            if dca.nomenclature =~ /pubchem.*(compound)|(cid)/i
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
              drug_claim.drug = drug if drug_claim.drug.nil?
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
          next unless drug_claim.drug.nil?
          indirect_groups = Hash.new { |h, k| h[k] = 0 }
          direct_groups = Hash.new { |h, k| h[k] = 0 }
          direct_groups[drug_claim.name] += 1 if DataModel::Drug.where(name: drug_claim.name).any?
          drug_claim.drug_claim_aliases.each do |drug_claim_alias|
            direct_groups[drug_claim_alias.alias] +=1 if DataModel::Drug.where(name: drug_claim_alias.alias).any?
            alt_drugs = @alt_to_other[drug_claim_alias.alias].map(&:drug_claim)
            alt_drugs.each do |alt_drug|
              indirect_drug = alt_drug.drug
              indirect_groups[indirect_drug.name] += 1 if indirect_drug
            end
            nomenclature = drug_claim_alias.nomenclature
            if nomenclature =~ /pubchem.*(compound)|(cid)/i
              alt_drugs = @alt_to_pubchem_cid[drug_claim_alias.alias].map(&:drug_claim)
              alt_drugs.each do |alt_drug|
                indirect_drug = alt_drug.drug
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

      def self.add_aliases
        DataModel::Drug.all.each do |drug|
          grouped_drug_claim_aliases = drug.drug_claims.flat_map(&:drug_claim_aliases).group_by { |dca| dca.alias.upcase }
          grouped_drug_claim_aliases.each do |name, drug_claim_aliases_for_name|
            groups = drug_claim_aliases_for_name.group_by{ |dca| dca.alias }
            counts_for_name = groups.each_with_object(Hash.new) do |(n, dcas), counts|
              counts[n] = dcas.length
            end
            best_name = Hash[counts_for_name.sort_by{ |n, count| count }.reverse].keys.first
            drug_alias = DataModel::DrugAlias.where(
              drug_id: drug.id,
              alias: best_name,
            ).first_or_create
            drug_claim_aliases_for_name.each do |dca|
              unless drug_alias.sources.include? dca.drug_claim.source
                drug_alias.sources << dca.drug_claim.source
              end
            end
            drug_alias.save
          end
        end
      end

      def self.add_attributes
        DataModel::Drug.all.each do |drug|
          drug.drug_claims.each do |drug_claim|
            drug_claim.drug_claim_attributes.each do |dca|
              existing_drug_attributes = DataModel::DrugAttribute.where(
                drug_id: drug.id,
                name: dca.name,
                value: dca.value
              )
              if existing_drug_attributes.empty?
                DataModel::DrugAttribute.new.tap do |a|
                  a.drug = drug
                  a.name = dca.name
                  a.value = dca.value
                  a.sources << drug_claim.source
                  a.save
                end
              else
                existing_drug_attributes.each do |drug_attribute|
                  unless drug_attribute.sources.include? drug_claim.source
                    drug_attribute.sources << drug_claim.source
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
