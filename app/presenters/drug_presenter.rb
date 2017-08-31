class DrugPresenter < SimpleDelegator
  attr_reader :drug
  def initialize(drug)
    @drug = drug
    super
  end

  def source_db_names
    @uniq_db_names ||= DataModel::Source.source_names_with_drug_claims
  end

  def grouped_names
    @grouped_names ||= group_map(@drug)
  end

  def group_map(drug)
    hash = drug_claims.each_with_object({}) do |drug_claim, h|
      source_db_name = drug_claim.source.source_db_name
      names = drug_claim.drug_claim_aliases.map{|a| a.alias} << drug_claim.name
      names.each do |name|
        h[name] ||= Hash.new {|key, val| false}
        h[name][source_db_name] = true
      end
    end

    [].tap do |results|
      hash.each_pair do |key, value|
        results << GeneNamePresenter.new(key, value, source_db_names)
      end
    end
  end

  def sorted_claims
    drug_claims.sort_by{ |d| [(d.drug_claim_attributes.empty? ? 1 : 0), (DrugClaimPresenter.new(d).publications.empty? ? 1 : 0), (d.drug_claim_aliases.empty? ? 1 : 0), d.sort_value] }
  end

  def sorted_interactions
    interactions.sort_by{ |i| [(i.interaction_types.empty? ? 1 : 0), (i.interaction_attributes.length > i.publications.length + i.interaction_types.length ? 0 : 1), (i.publications.empty? ? 1 : 0)] }
  end

  def sorted_interactions_by_score
    interactions.sort_by{ |i| -(i.publications.count + i.interaction_claims.count)}
  end

  def publications
    interactions.map{|i| i.publications}.flatten.uniq
  end

  def data
    {
      name: drug.name,
      chembl_id: drug.chembl_id,
      fda_approved: drug.fda_approved,
      immunotherapy: drug.immunotherapy,
      anti_neoplastic: drug.anti_neoplastic,
      alias: drug.drug_aliases.map(&:alias),
    }
  end
end
