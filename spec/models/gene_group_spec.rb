require 'spec_helper'

describe GenomeModels::DataModel::GeneGroup do
  fixtures :all

  it "should have many genes" do
    gene_name_group("group_flt3").genes.should be_an_instance_of(Array)
    gene_name_group("group_flt3").genes.first.should be_an_instance_of(GenomeModels::DataModel::Gene)
  end

end
