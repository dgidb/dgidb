class DrugsController < ApplicationController

  def show
    drug = DataModel::Drug.for_show.where('lower(drugs.name) = ?', params[:name].downcase)
      .first
    if drug.nil? || (@drugs && @drugs.count != 1)
      redirect_to controller: :interaction_claims, action: 'interaction_search_results',
                  name: params[:name], anchor: 'terms' and return
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
end
