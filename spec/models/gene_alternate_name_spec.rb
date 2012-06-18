require 'spec_helper'

describe DataModel::GeneAlternateName do
  set_fixture_class :gene_name_report_association => DataModel::GeneAlternateName
  fixtures :all
  it "should have a gene" do
    gene_name_report_association("drugbank_flt3").gene.should be_an_instance_of(DataModel::Gene)
  end
end
