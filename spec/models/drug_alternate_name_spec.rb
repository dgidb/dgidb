require 'spec_helper'

describe DataModel::DrugAlternateName do
  fixtures :drug_name_report_association, :drug_name_report
  it "should have a drug" do
    drug_name_report_association(:b).drug.should be_an_instance_of(DataModel::Drug)
  end
end
