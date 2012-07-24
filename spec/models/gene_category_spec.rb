require 'spec_helper'

describe GenomeModels::DataModel::GeneCategory do
  fixtures :all

  it "should have a gene" do
    gene_name_report_category_association("a").gene.should be_an_instance_of(GenomeModels::DataModel::Gene)
  end
end
