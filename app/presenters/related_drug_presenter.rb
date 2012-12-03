class RelatedDrugPresenter
  include Genome::Extensions
  def initialize(drug)
    @drug = drug
  end

  def name_link(context)
    case @drug
    when DataModel::DrugGroup
      context.link_to @drug.name, context.drug_group_path(@drug.name)
    when DataModel::Drug
      context.link_to @drug.name, context.drug_path(@drug.name)
    end
  end
end
