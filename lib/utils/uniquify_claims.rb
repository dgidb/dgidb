module Utils
  module UniquifyClaims

    def self.run
      ActiveRecord::Base.transaction do
        uniquify_gene_claims
        uniquify_drug_claims
        uniquify_interaction_claims
      end
    end

    def self.uniquify_gene_claims
      DataModel::GeneClaim.find_each do |gc|
        all_matching_claims = DataModel::GeneClaim.where(name: gc.name, nomenclature: gc.nomenclature, source_id: gc.source_id).all
        next if all_matching_claims.length == 1

        master_claim = all_matching_claims.shift
        all_matching_claims.each do |c|
          attributes = c.gene_claim_attributes.all
          attributes.each do |a|
            DataModel::GeneClaimAttribute.where(
              gene_claim_id: master_claim.id,
              name: a.name,
              value: a.value
            ).first_or_create
            a.delete
          end
          aliases = c.gene_claim_aliases.all
          aliases.each do |a|
            DataModel::GeneClaimAlias.where(
              gene_claim_id: master_claim.id,
              alias: a.alias,
              nomenclature: a.nomenclature
            ).first_or_create
            a.delete
          end
          categories = c.gene_claim_categories.all
          categories.each do |cat|
            unless master_claim.gene_claim_categories.include? cat
              master_claim.gene_claim_categories << cat
            end
            c.gene_claim_categories.delete(cat)
          end
          master_claim.save
          c.delete
        end
      end
    end

    def self.uniquify_drug_claims
      DataModel::DrugClaim.find_each do |dc|
        all_matching_claims = DataModel::DrugClaim.where(name: dc.name, nomenclature: dc.nomenclature, source_id: dc.source_id).all
        next if all_matching_claims.length == 1

        master_claim = all_matching_claims.shift
        all_matching_claims.each do |c|
          attributes = c.drug_claim_attributes.all
          attributes.each do |a|
            DataModel::DrugClaimAttribute.where(
              drug_claim_id: master_claim.id,
              name: a.name,
              value: a.value
            ).first_or_create
            a.delete
          end
          aliases = c.drug_claim_aliases.all
          aliases.each do |a|
            DataModel::DrugClaimAlias.where(
              drug_claim_id: master_claim.id,
              alias: a.alias,
              nomenclature: a.nomenclature
            ).first_or_create
            a.delete
          end
          types = c.drug_claim_types.all
          types.each do |t|
            unless master_claim.drug_claim_types.include? t
              master_claim.drug_claim_types << t
            end
            c.drug_claim_types.delete(t)
          end
          master_claim.save
          c.delete
        end
      end
    end

    def self.uniquify_interaction_claims
      DataModel::InteractionClaim.find_each do |ic|
        all_matching_claims = DataModel::InteractionClaim.where(drug_claim_id: ic.drug_claim_id, gene_claim_id: ic.gene_claim_id, source_id: ic.source_id).all
        next if all_matching_claims.length == 1

        master_claim = all_matching_claims.shift
        all_matching_claims.each do |c|
          attributes = c.interaction_claim_attributes.all
          attributes.each do |a|
            DataModel::InteractionClaimAttribute.where(
              interaction_claim_id: master_claim.id,
              name: a.name,
              value: a.value
            ).first_or_create
            a.delete
          end
          types = c.interaction_claim_types.all
          types.each do |t|
            unless master_claim.interaction_claim_types.include? t
              master_claim.interaction_claim_types << t
            end
            c.interaction_claim_types.delete(t)
          end
          publications = c.publications.all
          publications.each do |p|
            unless master_claim.publications.include? p
              master_claim.publications << p
            end
            c.publications.delete(p)
          end
          master_claim.save
          c.delete
        end
      end
    end

  end
end
