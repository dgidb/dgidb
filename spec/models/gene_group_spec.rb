require 'spec_helper'

describe DataModel::GeneGroup do
  it "should have many genes" do
    gene_group = DataModel::GeneGroup.new
    gene_group.genes.should be_an_instance_of(Array)
  end
end
