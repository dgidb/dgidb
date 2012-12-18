class RelatedDrugPresenter
  include Genome::Extensions
  def initialize(drug)
    @drug = drug
  end

  def name_link(context)
    context.link_to @drug.name, context.drug_path(@drug.name)
  end
end
