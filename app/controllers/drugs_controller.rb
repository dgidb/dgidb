class DrugsController < ApplicationController

  def show
    drug = DataModel::Drug.for_show.where('lower(drugs.name) = ?', CGI::unescape(params[:name].downcase))
      .first || not_found("No drug matches name #{params[:name]}")

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
