require 'spec_helper'

describe GenomeModels::DataModel::Interaction do
  set_fixture_class :drug_gene_interaction_report => GenomeModels::DataModel::Interaction
  fixtures :all

  it "should have many attributes" do
    drug_gene_interaction_report("drugbank_b").interaction_attributes.should be_an_instance_of(Array)
    drug_gene_interaction_report("drugbank_b").interaction_attributes.first.should be_an_instance_of(GenomeModels::DataModel::InteractionAttribute)
  end

  it 'should have a citation' do
    drug_gene_interaction_report("drugbank_b").citation.should be_an_instance_of(GenomeModels::DataModel::Citation)
  end

  it 'should have a drug' do
    drug_gene_interaction_report("drugbank_b").drug.should be_an_instance_of(GenomeModels::DataModel::Drug)
  end
  
  it 'should have a gene' do
    drug_gene_interaction_report("drugbank_b").gene.should be_an_instance_of(GenomeModels::DataModel::Gene)
  end

end
