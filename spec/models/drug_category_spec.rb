require 'spec_helper'

describe DataModel::DrugCategory do
  set_fixture_class :drug_name_report_category_association => DataModel::DrugCategory
  fixtures :all
  it "should have a drug" do
    drug_name_report_category_association("category_a").drug.should be_an_instance_of(DataModel::Drug)
  end
end
