require 'spec_helper'

describe DataModel::GeneGroup do
  fixtures :all

  it "should have many bridges" do
    gene_name_group("group_flt3").gene_group_bridges.should be_an_instance_of(Array)
    gene_name_group("group_flt3").gene_group_bridges.first.should be_an_instance_of(DataModel::GeneGroupBridge)
  end

  it "should have many genes" do
    gene_name_group("group_flt3").genes.should be_an_instance_of(Array)
    gene_name_group("group_flt3").genes.first.should be_an_instance_of(DataModel::Gene)
  end

end
