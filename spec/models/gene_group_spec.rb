require 'spec_helper'
##
require 'pry'
require 'pry-nav'
##

describe DataModel::GeneGroup do
  fixtures :all

  it "should have many genes" do
    gene_name_group("group_flt3").genes.should be_an_instance_of(Array)
    #binding.pry ###
    gene_name_group("group_flt3").genes.first.should be_an_instance_of(DataModel::Gene)
  end

end
