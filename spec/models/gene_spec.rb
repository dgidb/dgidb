require 'spec_helper'

describe DataModel::Gene do
  fixtures :all

  it "should have many groups" do
    gene_name_report("drugbank_flt3").gene_groups.should be_an_instance_of(Array)
    gene_name_report("drugbank_flt3").gene_groups.first.should be_an_instance_of(DataModel::GeneGroup)
  end

  it "should have many alternate names" do
    gene_name_report("drugbank_flt3").gene_alternate_names.should be_an_instance_of(Array)
    gene_name_report("drugbank_flt3").gene_alternate_names.first.should be_an_instance_of(DataModel::GeneAlternateName)
  end

  it "should have many categories" do
    gene_name_report("has_categories").gene_categories.should be_an_instance_of(Array)
    gene_name_report("has_categories").gene_categories.first.should be_an_instance_of(DataModel::GeneCategory)
  end

  it "should have many interactions" do
    gene_name_report("drugbank_flt3").interactions.should be_an_instance_of(Array)
    gene_name_report("drugbank_flt3").interactions.first.should be_an_instance_of(DataModel::Interaction)
  end

  it "should have many drugs" do
    gene_name_report("drugbank_flt3").drugs.should be_an_instance_of(Array)
    gene_name_report("drugbank_flt3").drugs.first.should be_an_instance_of(DataModel::Drug)
  end

  it 'should have a citation' do
    gene_name_report("drugbank_flt3").citation.should be_an_instance_of(DataModel::Citation)
  end

end
