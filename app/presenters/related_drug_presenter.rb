class RelatedDrugPresenter
  include Genome::Extensions
  def initialize(drug)
    @drug = drug
  end

  def name_link(context)
    case @drug
    when DataModel::Drug
      context.link_to @drug.name, context.drug_path(@drug.name)
    when DataModel::DrugClaim
      context.link_to @drug.name, context.drug_claim_path(@drug.name)
    end
  end
end
