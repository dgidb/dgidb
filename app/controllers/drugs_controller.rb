class DrugsController < ApplicationController

  def show
    drug = DataModel::Drug.for_show.where('lower(drugs.name) = ?', params[:name].downcase)
      .first ||
      related_drugs.first
    if drug.nil?
      raise()
      #TODO: Redirect to a drug search on params[:name]
    end
    if drug.instance_of?(RelatedDrugPresenter)
      drug = drug.drug
    end
    @drug = DrugPresenter.new(drug)
    @title = @drug.name
  end

  def names
    @names = DataModel::Drug.all_drug_names
    respond_to do |format|
      format.json {render json:  @names.to_json}
    end
  end

  def related_drugs
    @drugs = LookupRelatedDrugs.find(params[:name])
  end
end
