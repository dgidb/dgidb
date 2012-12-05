require 'spec_helper'

describe DataModel::GeneAlternateName do
  fixtures :all
  it "should have a gene" do
    gene_name_report_association("drugbank_flt3").gene.should be_an_instance_of(DataModel::Gene)
  end
end
